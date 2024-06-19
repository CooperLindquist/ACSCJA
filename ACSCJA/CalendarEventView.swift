import SwiftUI
import Firebase
import FirebaseFirestore

struct CalendarEventView: View {
    @StateObject private var viewModel = CalendarEventViewModel()
    @State private var showingAddEventSheet = false
    var sport: String
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil

    var body: some View {
        NavigationView {
            VStack {
                Text("\(sport) Calendar Events")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                CalendarGridView(currentDate: $currentDate, selectedDate: $selectedDate, events: viewModel.calendarEvents)

                if let selectedDate = selectedDate {
                    Text("Events on \(selectedDate, formatter: DateFormatter.shortDateFormatter)")
                        .font(.title2)
                        .padding()

                    ScrollView {
                        ForEach(eventsForSelectedDate(), id: \.id) { event in
                            HStack {
                                Image("calendarimage")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30.0)
                                VStack(alignment: .leading) {
                                    Text(event.title)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    Text(event.description)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                    }
                }
            }
            .navigationTitle(sport)
            .background(Image("HomePageBackground").ignoresSafeArea(.all))
            .onAppear {
                viewModel.getCalendarEvents(for: sport)
            }
            .navigationBarItems(trailing: Button(action: {
                showingAddEventSheet = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.black)
            })
            .sheet(isPresented: $showingAddEventSheet) {
                AddCalendarEventView(viewModel: viewModel, sport: sport)
            }
        }
    }

    private func eventsForSelectedDate() -> [CalendarEvent] {
        guard let selectedDate = selectedDate else { return [] }
        return viewModel.calendarEvents.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
}


struct CalendarGridView: View {
    @Binding var currentDate: Date
    @Binding var selectedDate: Date?
    var events: [CalendarEvent]

    private var calendar: Calendar {
        Calendar.current
    }

    private var daysInMonth: Int {
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        return range.count
    }

    private var firstWeekday: Int {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let firstDayOfMonth = calendar.date(from: components)!
        return calendar.component(.weekday, from: firstDayOfMonth)
    }

    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }

    private var days: [String] {
        calendar.shortWeekdaySymbols
    }

    private func hasEvents(on day: Int) -> Bool {
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = day
        let date = calendar.date(from: components)!
        return events.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text(monthYearFormatter.string(from: currentDate))
                    .font(.title)
                    .padding()
                Spacer()
                Button(action: {
                    currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 10) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }

                ForEach(1..<firstWeekday, id: \.self) { _ in
                    Text("")
                        .frame(maxWidth: .infinity)
                }

                ForEach(1...daysInMonth, id: \.self) { day in
                    VStack {
                        Text("\(day)")
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                selectDate(day: day)
                            }
                            .background(selectedDateBackground(day: day))
                        if hasEvents(on: day) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .padding(.top, 2)
                        }
                    }
                }
            }
            .padding()
        }
    }

    private func selectDate(day: Int) {
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = day
        selectedDate = calendar.date(from: components)
    }

    private func selectedDateBackground(day: Int) -> some View {
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = day
        let date = calendar.date(from: components)!
        return calendar.isDate(date, inSameDayAs: selectedDate ?? Date()) ? Color.blue.opacity(0.2) : Color.clear
    }
}

struct AddCalendarEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var sport: String
    @ObservedObject var viewModel: CalendarEventViewModel

    init(viewModel: CalendarEventViewModel, sport: String) {
        self.viewModel = viewModel
        self._sport = State(initialValue: sport)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Calendar Event Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationBarTitle("Add Calendar Event", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                let newEvent = CalendarEvent(title: title, description: description, sport: sport, date: date)
                viewModel.addCalendarEvent(newEvent)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

class CalendarEventViewModel: ObservableObject {
    @Published var calendarEvents: [CalendarEvent] = []
    private var db = Firestore.firestore()

    func getCalendarEvents(for sport: String) {
        db.collection("CalendarEvents").whereField("Sport", isEqualTo: sport).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.calendarEvents = snapshot?.documents.compactMap { document -> CalendarEvent? in
                    let data = document.data()
                    let title = data["Title"] as? String ?? "No Title"
                    let description = data["Description"] as? String ?? "No Description"
                    let date = (data["Date"] as? Timestamp)?.dateValue() ?? Date()
                    let id = document.documentID
                    return CalendarEvent(id: id, title: title, description: description, sport: sport, date: date)
                } ?? []
            }
        }
    }

    func addCalendarEvent(_ event: CalendarEvent) {
        let newEventRef = db.collection("CalendarEvents").document()
        newEventRef.setData([
            "Title": event.title,
            "Description": event.description,
            "Sport": event.sport,
            "Date": Timestamp(date: event.date)
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                self.getCalendarEvents(for: event.sport)
            }
        }
    }
}

struct CalendarEvent: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var description: String
    var sport: String
    var date: Date

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension DateFormatter {
    static var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

struct CalendarEventView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarEventView(sport: "Baseball")
    }
}

import SwiftUI
import Firebase
import FirebaseFirestore

struct SportHomeView: View {
    @StateObject private var viewModel = SportHomeViewModel()
    @State private var showingAddEventSheet = false
    var sport: String

    var body: some View {
        NavigationView {
            VStack {
                Text("\(sport) Events")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                ScrollView {
                    ForEach(viewModel.events, id: \.id) { event in
                        HStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray) // Placeholder for image or icon
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(event.subject)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text(event.formattedDate)
                                        .foregroundColor(.black)
                                }
                                Text(event.event)
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
            .navigationTitle(sport)
            .background(Image("HomePageBackground").ignoresSafeArea(.all))
            .onAppear {
                viewModel.getEvents(for: sport)
            }
            .navigationBarItems(trailing: Button(action: {
                showingAddEventSheet = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.black)
            })
            .sheet(isPresented: $showingAddEventSheet) {
                AddEventView(viewModel: viewModel, sport: sport)
            }
        }
    }
}



struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var subject = ""
    @State private var event = ""
    @State private var sport: String
    @ObservedObject var viewModel: SportHomeViewModel

    init(viewModel: SportHomeViewModel, sport: String) {
        self.viewModel = viewModel
        self._sport = State(initialValue: sport)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Subject", text: $subject)
                    TextField("Event", text: $event)
                }
            }
            .navigationBarTitle("Add Event", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                let newEvent = Event(subject: subject, event: event, sport: sport, date: Date())
                viewModel.addEvent(newEvent)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

class SportHomeViewModel: ObservableObject {
    @Published var events: [Event] = []
    private var db = Firestore.firestore()

    func getEvents(for sport: String) {
        db.collection("Events").whereField("Sport", isEqualTo: sport).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.events = snapshot?.documents.compactMap { document -> Event? in
                    let data = document.data()
                    let subject = data["Subject"] as? String ?? "No Subject"
                    let event = data["Event"] as? String ?? "No Event"
                    let date = (data["Date"] as? Timestamp)?.dateValue() ?? Date()
                    let id = document.documentID
                    return Event(id: id, subject: subject, event: event, sport: sport, date: date)
                } ?? []
            }
        }
    }

    func addEvent(_ event: Event) {
        let newEventRef = db.collection("Events").document()
        newEventRef.setData([
            "Subject": event.subject,
            "Event": event.event,
            "Sport": event.sport,
            "Date": Timestamp(date: event.date)
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                self.getEvents(for: event.sport)
            }
        }
    }
}

struct Event: Identifiable {
    var id: String = UUID().uuidString
    var subject: String
    var event: String
    var sport: String
    var date: Date

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

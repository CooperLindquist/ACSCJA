import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct SportHomeView: View {
    @ObservedObject var model = ViewModel()
    @StateObject private var viewModel = SportHomeViewModel()
    @State private var showingAddEventSheet = false
    var sport: String

    var body: some View {
        NavigationView {
            VStack {
                Text("\(sport) Updates")
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
                                    Text(event.displayName)
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
                viewModel.checkAdminStatus()
            }
            .navigationBarItems(trailing: Group {
                if viewModel.isAdmin {
                    Button(action: {
                        showingAddEventSheet = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
            })
            .sheet(isPresented: $showingAddEventSheet) {
                AddEventView(viewModel: viewModel, sport: sport)
            }
        }
    }
}







struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
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
                Section(header: Text("Type Message Here")) {
                    TextField("Message", text: $event)
                }
            }
            .navigationBarTitle("Send Message", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.addEvent(event: event, sport: sport) { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        // Handle the error, e.g., show an alert
                    }
                }
            })
        }
    }
}




class SportHomeViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isAdmin: Bool = false
    private var db = Firestore.firestore()

    func getEvents(for sport: String) {
        db.collection("Events").whereField("Sport", isEqualTo: sport).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.events.removeAll()
                let group = DispatchGroup()
                
                for document in snapshot!.documents {
                    group.enter()
                    
                    let data = document.data()
                    let subject = data["Subject"] as? String ?? "No Subject"
                    let event = data["Event"] as? String ?? "No Event"
                    let date = (data["Date"] as? Timestamp)?.dateValue() ?? Date()
                    let id = document.documentID
                    
                    self.db.collection("DisplayName").document(subject).getDocument { (displayNameDocument, error) in
                        if let displayNameDocument = displayNameDocument, displayNameDocument.exists {
                            let displayName = displayNameDocument.data()?["name"] as? String ?? "No Name"
                            let eventItem = Event(id: id, subject: subject, event: event, sport: sport, date: date, displayName: displayName)
                            self.events.append(eventItem)
                        } else {
                            print("DisplayName document does not exist or error: \(String(describing: error))")
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.events.sort(by: { $0.date < $1.date }) // Sort events by date
                }
            }
        }
    }

    func addEvent(event: String, sport: String, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        db.collection("DisplayName").document(userID).getDocument { (document, error) in
            if let document = document, document.exists, let displayName = document.data()?["name"] as? String {
                let newEvent = Event(subject: userID, event: event, sport: sport, date: Date(), displayName: displayName)
                let newEventRef = self.db.collection("Events").document()
                newEventRef.setData([
                    "Subject": newEvent.subject,
                    "Event": newEvent.event,
                    "Sport": newEvent.sport,
                    "Date": Timestamp(date: newEvent.date)
                ]) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                        completion(false)
                    } else {
                        self.getEvents(for: sport)
                        completion(true)
                    }
                }
            } else {
                print("Error fetching display name: \(String(describing: error))")
                completion(false)
            }
        }
    }

    func checkAdminStatus() {
        guard let userID = Auth.auth().currentUser?.uid else {
            self.isAdmin = false
            return
        }
        
        db.collection("Admin").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                self.isAdmin = document.data()?["Admin"] as? Bool ?? false
            } else {
                print("Document does not exist or error: \(String(describing: error))")
                self.isAdmin = false
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
    var displayName: String

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


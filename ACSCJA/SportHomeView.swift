import SwiftUI
import Firebase
import FirebaseFirestore

struct SportHomeView: View {
    @StateObject private var viewModel = SportHomeViewModel()
    var sport: String

    var body: some View {
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
                            Text(event.subject)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
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
        .onAppear {
            viewModel.getEvents(for: sport)
        }
        .navigationTitle(sport)
        .background(Image("HomePageBackground").ignoresSafeArea(.all))
        
    }
}

struct SportHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SportHomeView(sport: "Baseball")
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
                    let id = document.documentID
                    return Event(id: id, subject: subject, event: event)
                } ?? []
            }
        }
    }
}

struct Event: Identifiable {
    var id: String
    var subject: String
    var event: String
}

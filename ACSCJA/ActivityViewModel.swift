import Foundation
import Firebase
import FirebaseFirestore

class ActivityViewModel: ObservableObject {
    @Published var availableSports: [String] = []
    private var db = Firestore.firestore()
    var userID: String = "" // Remove the default hardcoded value

    func getAvailableSports() {
        db.collection("Score").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let sports = snapshot?.documents.compactMap { $0.data()["Sport"] as? String } ?? []
                self.availableSports = Array(Set(sports)) // Remove duplicates
            }
        }
    }

    func checkMembership(for sport: String, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        db.collection(sport).document(userID).getDocument { document, error in
            if let document = document, document.exists, let isMember = document.data()?["Member"] as? Bool {
                completion(isMember)
            } else {
                completion(false)
            }
        }
    }
}

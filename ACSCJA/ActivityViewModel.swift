import Foundation
import Firebase
import FirebaseFirestore

class ActivityViewModel: ObservableObject {
    @Published var availableSports: [String] = []
    @Published var followedSports: [String] = []
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
    func getFollowedSports() {
            guard !userID.isEmpty else { return }
            db.collection("FollowedActivity").document(userID).getDocument { document, error in
                if let document = document, document.exists, let data = document.data() {
                    self.followedSports = data["sports"] as? [String] ?? []
                }
            }
        }

        func followSport(_ sport: String) {
            guard !userID.isEmpty else { return }
            db.collection("FollowedActivity").document(userID).setData([
                "sports": FieldValue.arrayUnion([sport])
            ], merge: true) { error in
                if let error = error {
                    print("Error following sport: \(error)")
                } else {
                    self.getFollowedSports()
                }
            }
        }

        func unfollowSport(_ sport: String) {
            guard !userID.isEmpty else { return }
            db.collection("FollowedActivity").document(userID).updateData([
                "sports": FieldValue.arrayRemove([sport])
            ]) { error in
                if let error = error {
                    print("Error unfollowing sport: \(error)")
                } else {
                    self.getFollowedSports()
                }
            }
        }
    }

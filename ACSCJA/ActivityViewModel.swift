import Foundation
import Firebase
import FirebaseFirestore


class ActivityViewModel: ObservableObject {
    @Published var FollowedActivities: [String] = []
    @Published var availableSports: [String] = []
    private var db = Firestore.firestore()
    var userID: String = "" // Remove the default hardcoded value
    
    func getFollowedActivities() {
        guard !userID.isEmpty else { return }
        
        db.collection("users").document(userID).collection("FollowedActivities").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.FollowedActivities = snapshot?.documents.compactMap { $0.data()["activity"] as? String } ?? []
            }
        }
    }
    
    func addFollowedActivity(_ activity: String) {
        guard !userID.isEmpty else { return }
        guard !FollowedActivities.contains(activity) else { return } // Check for duplicates
        
        db.collection("users").document(userID).collection("FollowedActivities").addDocument(data: ["activity": activity]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                self.getFollowedActivities()
            }
        }
    }
    
    func removeFollowedActivity(_ activity: String) {
        guard !userID.isEmpty else { return }
        
        db.collection("users").document(userID).collection("FollowedActivities").whereField("activity", isEqualTo: activity).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    self.db.collection("users").document(self.userID).collection("FollowedActivities").document(document.documentID).delete { error in
                        if let error = error {
                            print("Error removing document: \(error)")
                        } else {
                            self.getFollowedActivities()
                        }
                    }
                }
            }
        }
    }
    
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
}

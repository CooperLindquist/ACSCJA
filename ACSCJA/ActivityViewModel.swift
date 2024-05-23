import Foundation
import Firebase
import FirebaseFirestore

class ActivityViewModel: ObservableObject {
    @Published var followedActivities: [String] = []
    private var db = Firestore.firestore()
    private var userID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    func getFollowedActivities() {
        guard let userID = userID else { return }
        
        db.collection("FollowedActivities").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                DispatchQueue.main.async {
                    self.followedActivities = document.data()?["activities"] as? [String] ?? []
                }
            } else {
                DispatchQueue.main.async {
                    self.followedActivities = []
                }
            }
        }
    }
    
    func addFollowedActivity(_ activity: String) {
        guard let userID = userID else { return }
        
        followedActivities.append(activity)
        
        db.collection("FollowedActivities").document(userID).setData(["activities": followedActivities]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            }
        }
    }
}

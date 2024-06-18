import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ViewModel: ObservableObject {
    @Published var array = [Score]()
    @Published var followedActivities = [String]()
    @Published var isAdmin: Bool = false // Add this property to track admin status
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getData()
        checkAdminStatus() // Check admin status on initialization
    }
    
    func getData() {
        fetchScores()
        fetchFollowedActivities()
    }
    
    func getData2() {
        let db = Firestore.firestore()
        db.collection("Score").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                return
            }
            
            DispatchQueue.main.async {
                self.array = snapshot.documents.compactMap { document in
                    let data = document.data()
                    guard
                        let awayTeam = data["AwayTeam"] as? String,
                        let date = data["Date"] as? String,
                        let epsScore = data["EPScore"] as? Int,
                        let otherScore = data["OtherScore"] as? Int,
                        let sport = data["Sport"] as? String,
                        let gender = data["Gender"] as? String,
                        let level = data["Level"] as? String
                    else {
                        print("Invalid data for document \(document.documentID)")
                        return nil
                    }
                    
                    return Score(
                        id: document.documentID,
                        Date: date,
                        AwayTeam: awayTeam,
                        EPScore: epsScore,
                        OtherScore: otherScore,
                        Sport: sport,
                        Gender: gender,
                        Level: level
                    )
                }
            }
        }
    }
    
    private func fetchScores() {
        let db = Firestore.firestore()
        db.collection("Scores").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.array = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Score.self)
                } ?? []
                print("Fetched scores: \(self.array)") // Debugging line
            }
        }
    }
    
    private func fetchFollowedActivities() {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        print("Fetching followed activities for user ID: \(userID)") // Debugging line
        db.collection("FollowedActivities").document(userID).getDocument { (document, error) in
            if let error = error {
                print("Error getting followed activities document: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                self.followedActivities = document.data()?["activities"] as? [String] ?? []
                print("Fetched followed activities: \(self.followedActivities)") // Debugging line
            } else {
                print("Followed activities document does not exist")
            }
        }
    }
    
     func checkAdminStatus() {
        guard let userID = Auth.auth().currentUser?.uid else {
            self.isAdmin = false
            return
        }
        
        let db = Firestore.firestore()
        db.collection("Admin").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                self.isAdmin = document.data()?["Admin"] as? Bool ?? false
            } else {
                print("Document does not exist or error: \(String(describing: error))")
                self.isAdmin = false
            }
        }
    }
    
    var filteredScores: [Score] {
        array.filter { followedActivities.contains($0.Sport) }
    }
}

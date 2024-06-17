import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewModel: ObservableObject {
    @Published var array = [Score]()
    @Published var followedActivities = [String]()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getData()
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
                            let gender = data["Gender"] as? String
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
                            Gender: gender
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
        let userID = "your_user_id_here" // Replace this with the actual user ID
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

    
    var filteredScores: [Score] {
        array.filter { followedActivities.contains($0.Sport) }
    }
}

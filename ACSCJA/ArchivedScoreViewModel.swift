import Foundation
import Firebase

class ArchivedScoreViewModel: ObservableObject {
    @Published var array = [ArchivedScore]()
    
    func getData() {
        let db = Firestore.firestore()
        db.collection("ArchivedScore").getDocuments { snapshot, error in
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
                    
                    return ArchivedScore(
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
}

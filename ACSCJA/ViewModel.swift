//
//  ViewModel.swift
//  ACSCJA
//
//  Created by 90310805 on 4/22/24.
//

import Foundation
import Firebase

class ViewModel: ObservableObject {
    static let shared = ViewModel() // Shared instance
    
    @Published var list = [Score]()
    
    func getData() {
        let db = Firestore.firestore()
        
        
        db.collection("Score").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map { document in
                            let data = document.data()
                            let id = document.documentID
                            let awayTeam = data["AwayTeam"] as? String ?? ""
                            let epsScore = data["EPScore"] as? Int ?? 0
                            let otherScore = data["OtherScore"] as? Int ?? 0
                            let sport = data["Sport"] as? String ?? ""
                            return Score(id: id, AwayTeam: awayTeam, EPScore: epsScore, OtherScore: otherScore, Sport: sport)
                        }
                    }
                } else {
                    print("Snapshot is nil")
                }
            }
        }
    }
}

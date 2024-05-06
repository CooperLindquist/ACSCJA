import SwiftUI
import Firebase

struct AddScoreView: View {
    @State private var awayTeamString: String = ""
    @State private var epsScoreString: String = ""
    @State private var otherScoreString: String = ""
    @State private var sport: String = ""
    
    var body: some View {
        ZStack {
            Image("HomePageBackground")
        
            VStack {
                TextField("Away Team", text: $awayTeamString)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 300)
                
                TextField("EPS Score", text: $epsScoreString)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(maxWidth: 300)
                
                TextField("Other Score", text: $otherScoreString)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(maxWidth: 300)
                
                TextField("Sport", text: $sport)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 300)
                
                Button(action: {
                    saveScore()
                }) {
                    Text("Save Score")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
                Button(action: {
                    updateScore()
                }) {
                    Text("Update Score")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
                Button(action: {
                    clearCollection(collectionPath: "Score")
                }) {
                    Text("Clear All Scores")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
    }
    
    func updateScore() {
        guard let epsScore = Int(epsScoreString),
              let otherScore = Int(otherScoreString) else {
            // Handle invalid input
            return
        }
        
        let db = Firestore.firestore()
        
        // Get the away team from the @State variable
        let awayTeam = awayTeamString
        
        // Query the collection to find the document(s) that match the Sport name
        db.collection("Score")
            .whereField("Sport", isEqualTo: sport)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error querying documents: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Snapshot is nil")
                    return
                }
                
                for document in snapshot.documents {
                    // Update each matching document with the new scores
                    db.collection("Score")
                        .document(document.documentID)
                        .updateData([
                            "AwayTeam": awayTeam,
                            "EPScore": epsScore,
                            "OtherScore": otherScore
                        ]) { error in
                            if let error = error {
                                print("Error updating document: \(error.localizedDescription)")
                            } else {
                                print("Document updated successfully")
                                // Optionally, you can clear the text fields after updating
                                self.awayTeamString = ""
                                self.epsScoreString = ""
                                self.otherScoreString = ""
                                self.sport = ""
                            }
                        }
                }
            }
    }
    
    func saveScore() {
        guard let epsScore = Int(epsScoreString),
              let otherScore = Int(otherScoreString) else {
            // Handle invalid input
            return
        }
        
        let db = Firestore.firestore()
        db.collection("Score").addDocument(data: [
            "AwayTeam": awayTeamString,
            "EPScore": epsScore,
            "OtherScore": otherScore,
            "Sport": sport
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added successfully")
                // Optionally, you can clear the text fields after saving
                self.awayTeamString = ""
                self.epsScoreString = ""
                self.otherScoreString = ""
                self.sport = ""
            }
        }
    }
    
    func clearCollection(collectionPath: String) {
        let db = Firestore.firestore()
        db.collection(collectionPath).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error clearing collection: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                return
            }
            
            let batch = db.batch()
            snapshot.documents.forEach { document in
                batch.deleteDocument(db.collection(collectionPath).document(document.documentID))
            }
            
            batch.commit { error in
                if let error = error {
                    print("Error committing batch delete: \(error.localizedDescription)")
                } else {
                    print("Collection cleared successfully")
                }
            }
        }
    }
}

struct AddScoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddScoreView()
    }
}

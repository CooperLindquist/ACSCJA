import SwiftUI
import Firebase

struct AddScoreView: View {
    @State private var awayTeamString: String = ""
    @State private var date = Date() // Change to use Date type instead of String
    @State private var epsScoreString: String = ""
    @State private var otherScoreString: String = ""
    @State private var sport: String = ""
    
    var body: some View {
        
        ZStack {
            Image("HomePageBackground")
            
            VStack {
                Text("Add Score")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .underline()
                TextField("Away Team", text: $awayTeamString)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 300)
                
                DatePicker("Date", selection: $date, displayedComponents: .date) // Use DatePicker for date input
                    .padding()
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
        .onAppear {
            self.setupDocumentRemovalTimer()
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
        
        // Convert Date to string in "00/00/0000" format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: date)
        
        // Query the collection to find the document(s) that match the Sport name
        db.collection("Score")
            .whereField("Sport", isEqualTo: sport)
            .getDocuments { (snapshot, error) in
                // ... existing code
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
                            "Date": dateString, // Store date as string
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.string(from: date)
            
            // Add a timestamp for 7 days in the future
            let futureTimestamp = Calendar.current.date(byAdding: .day, value: 7, to: date) ?? Date()
            
            db.collection("Score").addDocument(data: [
                "AwayTeam": awayTeamString,
                "Date": dateString,
                "EPScore": epsScore,
                "OtherScore": otherScore,
                "Sport": sport,
                "Timestamp": futureTimestamp.timeIntervalSince1970 // Add future timestamp
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
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

    private func addNewScore(db: Firestore, dateString: String, epsScore: Int, otherScore: Int) {
        // Add the new score to "Score"
        db.collection("Score").addDocument(data: [
            "AwayTeam": awayTeamString,
            "Date": dateString,
            "EPScore": epsScore,
            "OtherScore": otherScore,
            "Sport": sport
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
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
    func setupDocumentRemovalTimer() {
            // Create a Timer to call removeExpiredDocuments() every hour
            Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { _ in
                self.removeExpiredDocuments()
            }
        }
    func removeExpiredDocuments() {
            let db = Firestore.firestore()
            let currentTimestamp = Date().timeIntervalSince1970
            
            db.collection("Score").whereField("Timestamp", isLessThan: currentTimestamp).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error removing expired documents: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Snapshot is nil")
                    return
                }
                
                let batch = db.batch()
                for document in snapshot.documents {
                    batch.deleteDocument(db.collection("Score").document(document.documentID))
                }
                
                batch.commit { error in
                    if let error = error {
                        print("Error committing batch delete: \(error.localizedDescription)")
                    } else {
                        print("Expired documents removed successfully")
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


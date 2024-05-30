import SwiftUI
import Firebase

struct AddScoreView: View {
    @State private var selectedAwayTeam: String = "Hopkins"
    @State private var date = Date()
    @State private var epsScoreString: String = ""
    @State private var otherScoreString: String = ""
    @State private var selectedSport: String = "Football"
    @State private var customAwayTeam: String = ""
    @State private var customSport: String = ""
    
    let awayTeams = ["Hopkins", "Edina", "Wayzata", "Buffalo", "Minnetonka", "STMA", "Other"]
    let sports = ["Football", "Basketball", "Baseball", "Soccer", "Hockey", "Volleyball", "Lacrosse", "Other"]
    
    var body: some View {
        ZStack {
            Image("HomePageBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Add Score")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .underline()
                
                Menu {
                    ForEach(awayTeams, id: \.self) { team in
                        Button(action: {
                            selectedAwayTeam = team
                        }) {
                            Text(team)
                        }
                    }
                } label: {
                    Text("Away Team: \(selectedAwayTeam)")
                        .padding()
                        .frame(maxWidth: 300)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                    
                }
                .padding()
                .frame(maxWidth: 300)
                
                if selectedAwayTeam == "Other" {
                    TextField("Enter Away Team", text: $customAwayTeam)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 300)
                }
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
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
                
                Menu {
                    ForEach(sports, id: \.self) { sport in
                        Button(action: {
                            selectedSport = sport
                        }) {
                            Text(sport)
                        }
                    }
                } label: {
                    Text("Sport: \(selectedSport)")
                        .padding()
                        .frame(maxWidth: 300)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                .frame(maxWidth: 300)
                
                if selectedSport == "Other" {
                    TextField("Enter Sport", text: $customSport)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 300)
                }
                
                Button(action: {
                    saveOrUpdateScore()
                }) {
                    Text("Save Score")
                        .padding()
                        .frame(maxWidth: 270)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .padding()
                
//                Button(action: {
//                    clearCollection(collectionPath: "Score")
//                }) {
//                    Text("Clear All Scores")
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//                .padding()
            }
        }
    }
    
    func saveOrUpdateScore() {
        guard let epsScore = Int(epsScoreString),
              let otherScore = Int(otherScoreString) else {
            // Handle invalid input
            return
        }
        
        let db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: date)
        
        let awayTeam = selectedAwayTeam == "Other" ? customAwayTeam : selectedAwayTeam
        let sportToSave = selectedSport == "Other" ? customSport : selectedSport
        
        // Check if the document with the specified sport exists
        db.collection("Score")
            .whereField("Sport", isEqualTo: sportToSave)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error querying documents: \(error.localizedDescription)")
                    return
                }
                
                if let snapshot = snapshot, !snapshot.documents.isEmpty {
                    // Move the existing document(s) to ArchivedScore collection
                    for document in snapshot.documents {
                        moveDocumentToArchive(document: document)
                    }
                }
                
                // Add a new document or update the existing one
                db.collection("Score").addDocument(data: [
                    "AwayTeam": awayTeam,
                    "Date": dateString,
                    "EPScore": epsScore,
                    "OtherScore": otherScore,
                    "Sport": sportToSave,
                    "Timestamp": Date().timeIntervalSince1970
                ]) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added successfully")
                        // Optionally, you can clear the text fields after saving
                        self.selectedAwayTeam = awayTeams[0]
                        self.customAwayTeam = ""
                        self.epsScoreString = ""
                        self.otherScoreString = ""
                        self.selectedSport = sports[0]
                        self.customSport = ""
                    }
                }
            }
    }
    
    func moveDocumentToArchive(document: DocumentSnapshot) {
        let db = Firestore.firestore()
        let data = document.data() ?? [:]
        
        db.collection("ArchivedScore").addDocument(data: data) { error in
            if let error = error {
                print("Error adding document to ArchivedScore: \(error.localizedDescription)")
            } else {
                // Delete the original document from Score collection
                db.collection("Score").document(document.documentID).delete { error in
                    if let error = error {
                        print("Error deleting document from Score: \(error.localizedDescription)")
                    } else {
                        print("Document moved to ArchivedScore and deleted from Score successfully")
                    }
                }
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

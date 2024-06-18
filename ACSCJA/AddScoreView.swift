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
    @State private var selectedGender: String = "Boys"
    @State private var selectedLevel: String = "Varsity"
    @State private var showAlert = false

    let awayTeams = ["Hopkins", "Edina", "Wayzata", "Buffalo", "Minnetonka", "STMA", "Other"]
    let sports = ["Football", "Basketball", "Baseball", "Soccer", "Hockey", "Volleyball", "Lacrosse", "Other"]
    let genders = ["Boys", "Girls"]
    let levels = ["JV", "Varsity"]

    var body: some View {
        ZStack {
            Color(hex: "18181b")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Add Score")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)

                HStack(spacing: 20) {
                    CustomMenu(title: "Sport", selection: $selectedSport, options: sports)
                    if selectedSport == "Other" {
                        CustomTextField("Enter Sport", text: $customSport)
                    }
                    CustomMenu(title: "Away Team", selection: $selectedAwayTeam, options: awayTeams)
                    if selectedAwayTeam == "Other" {
                        CustomTextField("Enter Away Team", text: $customAwayTeam)
                    }
                }

                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .padding()
                    .frame(maxWidth: 300)
                    .background(Color(hex: "27272a"))
                    .cornerRadius(8)
                    .foregroundColor(.white)

                HStack(spacing: 20) {
                    CustomTextField("EP Score", text: $epsScoreString)
                        
                    CustomTextField("Other Score", text: $otherScoreString)
                }

                HStack(spacing: 20) {
                    CustomMenu(title: "Gender", selection: $selectedGender, options: genders)
                    CustomMenu(title: "Level", selection: $selectedLevel, options: levels)
                }

                Button(action: {
                    saveOrUpdateScore()
                }) {
                    Text("Save Score")
                        .padding()
                        .frame(maxWidth: 300)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Success"), message: Text("Score saved successfully"), dismissButton: .default(Text("OK")))
                }
            }
            .padding(.bottom, 50.0)
        }
    }

    func CustomTextField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .keyboardType(.numberPad) // Set keyboard to number pad
            .padding()
            .frame(maxWidth: 140)
            .background(Color(hex: "27272a"))
            .cornerRadius(8)
            .foregroundColor(.white)
            .placeholder(when: text.wrappedValue.isEmpty) {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
            }
    }

    func CustomMenu(title: String, selection: Binding<String>, options: [String]) -> some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selection.wrappedValue = option
                }) {
                    Text(option)
                        .foregroundColor(.white)
                }
            }
        } label: {
            Text("\(title): \(selection.wrappedValue)")
                .padding()
                .frame(maxWidth: 140)
                .foregroundColor(.white)
                .background(Color(hex: "27272a"))
                .cornerRadius(8)
        }
        .padding(.bottom, 10)
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

        db.collection("Score")
            .whereField("Sport", isEqualTo: sportToSave)
            .whereField("Gender", isEqualTo: selectedGender)
            .whereField("Level", isEqualTo: selectedLevel)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error querying documents: \(error.localizedDescription)")
                    return
                }

                if let snapshot = snapshot, !snapshot.documents.isEmpty {
                    for document in snapshot.documents {
                        moveDocumentToArchive(document: document)
                    }
                }

                db.collection("Score").addDocument(data: [
                    "AwayTeam": awayTeam,
                    "Date": dateString,
                    "EPScore": epsScore,
                    "OtherScore": otherScore,
                    "Sport": sportToSave,
                    "Gender": selectedGender,
                    "Level": selectedLevel,
                    "Timestamp": Date().timeIntervalSince1970
                ]) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added successfully")
                        self.selectedAwayTeam = awayTeams[0]
                        self.customAwayTeam = ""
                        self.epsScoreString = ""
                        self.otherScoreString = ""
                        self.selectedSport = sports[0]
                        self.customSport = ""
                        self.selectedGender = genders[0]
                        self.selectedLevel = levels[0]
                        self.showAlert = true
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
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}



struct AddScoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddScoreView()
    }
}

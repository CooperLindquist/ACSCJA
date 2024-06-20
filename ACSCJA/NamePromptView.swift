import SwiftUI
import FirebaseFirestore

struct NamePromptView: View {
    @Binding var userName: String
    @Binding var showingNamePrompt: Bool
    var userID: String
    var db = Firestore.firestore()

    var body: some View {
        VStack {
            Text("Please enter your name")
                .font(.headline)
                .padding()
            TextField("Name", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Save") {
                saveNameToFirestore()
            }
            .padding()
        }
        .padding()
    }

    private func saveNameToFirestore() {
        let userRef = db.collection("DisplayName").document(userID)
        userRef.setData(["name": userName]) { error in
            if let error = error {
                print("Error saving user name to Firestore: \(error.localizedDescription)")
            } else {
                print("User name successfully saved to Firestore.")
                showingNamePrompt = false
            }
        }
    }
}

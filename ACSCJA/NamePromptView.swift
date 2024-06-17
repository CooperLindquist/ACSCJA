import SwiftUI
import Firebase

struct NamePromptView: View {
    @Binding var userName: String
    @Binding var storedUserName: String
    @Binding var showingNamePrompt: Bool
    var userID: String

    var body: some View {
        VStack {
            Text("Enter your name")
                .font(.title)
                .padding()

            TextField("Name", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                storeUserName()
                showingNamePrompt = false
            }) {
                Text("OK")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    private func storeUserName() {
        // Store the user name in AppStorage for persistence
        storedUserName = userName
        
        // Update the user name in Firebase
        let db = Firestore.firestore()
        let userDocRef = db.collection("DisplayNames").document(userID)
        userDocRef.updateData(["name": userName]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}

struct NamePromptView_Previews: PreviewProvider {
    static var previews: some View {
        NamePromptView(userName: .constant(""), storedUserName: .constant(""), showingNamePrompt: .constant(true), userID: "some_user_id")
    }
}

//
//  ChangePasswordView.swift
//  ACSCJA
//
//  Created by Cooper Lindquist on 6/19/24.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @Binding var isPresented: Bool

    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""

    @State private var errorMessage: String?
    @State private var successMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                SecureField("Current Password", text: $currentPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                SecureField("New Password", text: $newPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                SecureField("Confirm New Password", text: $confirmNewPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                if let successMessage = successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    changePassword()
                }) {
                    Text("Change Password")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Change Password")
            .navigationBarItems(trailing: Button("Close") {
                isPresented = false
            })
        }
    }

    private func changePassword() {
        guard newPassword == confirmNewPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: currentPassword)
        
        user?.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                self.errorMessage = "Reauthentication failed: \(error.localizedDescription)"
                return
            }

            user?.updatePassword(to: newPassword) { error in
                if let error = error {
                    self.errorMessage = "Password update failed: \(error.localizedDescription)"
                } else {
                    self.successMessage = "Password successfully updated."
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(isPresented: .constant(true))
    }
}

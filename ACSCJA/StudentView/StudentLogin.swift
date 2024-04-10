//
//  StudentLogin.swift
//  ACSCJA
//
//  Created by 90310805 on 3/14/24.
//

import SwiftUI
import Firebase

struct StudentLogin: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    @State private var errorMessage = ""
    @State private var showErrorAlert = false
        
    var body: some View {
        if userIsLoggedIn {
            HomePageView()
        }
        else {
            content
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
        }
        
        
        
    }
        var content: some View{
            ZStack {
                Image("LoginBackround")
                
                Image("Login")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400.0)
                
                TextField("Username or email address", text: $email)
                    .foregroundColor(.gray)
                    .bold()
                    .frame(maxWidth: 288, maxHeight: 55)
                    .background(Color.white)
                    .cornerRadius(10.0) // Apply corner radius to the container
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(Color.gray, lineWidth: 1) // Apply border to the container
                    )
                    .offset(x: -3, y: 58)
                    .padding(.horizontal) // Add padding to ensure border is visible
                    .padding(.vertical, 5) // Add vertical padding to prevent cut-off
                
                SecureField("Password", text: $password)
                    .foregroundColor(.gray)
                    .bold()
                    .frame(maxWidth: 288, maxHeight: 55)
                    .background(Color.white)
                    .cornerRadius(10.0) // Apply corner radius to the container
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(Color.gray, lineWidth: 1) // Apply border to the container
                    )
                    .offset(x: -3, y: 173)
                    .padding(.horizontal) // Add padding to ensure border is visible
                    .padding(.vertical, 5) // Add vertical padding to prevent cut-off
                
                Button {
                    login()
                } label: {
                    Text("Sign in")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: 280)
                        .frame(maxHeight: 50)
                        
                                                
                        
                    
                }
                
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                .fill(.linearGradient(colors: [Color(red: 0.7, green: 0, blue: 0), Color(red: 0.7, green: 0, blue: 0)], startPoint: .top, endPoint: .bottomTrailing))
                        )

                .offset(y: 270)
                

                
            }
            
        }
    
    func login() {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    errorMessage = error.localizedDescription // Set error message
                    showErrorAlert = true // Show error alert
                    print(error.localizedDescription)
                } else {
                    // Authentication successful, set userIsLoggedIn to true
                    userIsLoggedIn = true
                }
            }
        }
    
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    }
    


#Preview {
    StudentLogin()
}
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}


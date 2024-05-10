//
//  SignUpView.swift
//  ACSCJA
//
//  Created by 90310805 on 5/10/24.
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleSignInSwift



struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    @State private var errorMessage = ""
    @State private var showErrorAlert = false
    @State var isLoading: Bool = false
    @AppStorage("log_Status") var log_Status = false
        
    var body: some View {
        NavigationView{
            if userIsLoggedIn {
                NavigationLink(destination: TabBarView()) {
                    Text("Enter")
                        .foregroundColor(.black)
                        .border(Color.blue)
                }
            }

            else {
                content
                    .alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }
            }
        }
        .navigationBarBackButtonHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        
        
        
        
        
    }
        var content: some View{
            ZStack {
                Image("LoginBackround")
                
                Image("white")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 480.0)
                    .offset(x: -10)
                Image("EPEagle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 220.0)
                    .offset(y: -260)
                Text("Welcome to")
                    .offset(x: -100, y: -170)
                Text("EPHS Activities")
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#AE0000"))
                    .offset(x: 15, y: -170)
                Text("Sign up")
                    .font(.custom("Poppins-Regular", size: 50))
                    
                    .offset(x: -60, y: -100)

                Text("Enter your email adress")
                    .offset(x: -60, y: -20)
                Text("Enter your password")
                    .offset(x: -70, y: 90)
                
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
                    .offset(x: -3, y: 28)
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
                    .offset(x: -3, y: 143)
                    .padding(.horizontal) // Add padding to ensure border is visible
                    .padding(.vertical, 5) // Add vertical padding to prevent cut-off
                
                Button {
                    
                } label: {
                    Text("Sign up")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: 280)
                        .frame(maxHeight: 50)
                }
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                .fill(.linearGradient(colors: [Color(red: 0.7, green: 0, blue: 0), Color(red: 0.7, green: 0, blue: 0)], startPoint: .top, endPoint: .bottomTrailing))
                        )

                .offset(y: 240)
                
                
            }
            .overlay(
                ZStack {
                    if isLoading {
                        Color.black
                            .opacity(0.25)
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .font(.title2)
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                })
            
        }
        
    
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    func getRootViewController() ->UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    // An error occurred while signing up
                    completion(error)
                } else {
                    // User successfully signed up
                    completion(nil)
                }
            }
        }
    func signUpButton() {
        signUp(email: email, password: password) { error in
            if let error = error {
                // Handle sign-up error
                errorMessage = error.localizedDescription
                showErrorAlert = true
                print("Error signing up:", error.localizedDescription)
            } else {
                // Sign-up successful
                print("Sign up successful!")
                // Optionally, you can automatically log in the user after sign-up
                
            }
        }
    }

    }
    


#Preview {
    SignUpView()
}

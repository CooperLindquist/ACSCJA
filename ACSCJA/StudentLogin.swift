//
//  StudentLogin.swift
//  ACSCJA
//
//  Created by 90310805 on 3/14/24.
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleSignInSwift



struct StudentLogin: View {
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
        
    
    func login() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
//          guard error == nil else {
//            // ...
//          }
//
//          guard let user = result?.user,
//            let idToken = user.idToken?.tokenString
//          else {
//            // ...
//          }
//
//          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                         accessToken: user.accessToken.tokenString)
//
//          // ...
//        
//
//            Auth.auth().signIn(with: credential) { result, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//                guard let user = result?.user else {
//                    return
//                }
//                print(user.displayName ?? "Success!")
//                withAnimation {
//                    log_Status = true
//                }
//            }
//        }
//    }

        
        
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
    func getRootViewController() ->UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
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


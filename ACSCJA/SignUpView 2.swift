import SwiftUI
import Firebase

struct SignUpView: View {
    @Binding var isSignedOut: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showErrorAlert = false
    @State private var isLoading: Bool = false
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            VStack {
                content
                    .alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }
            }
            .navigationBarBackButtonHidden(false)
            .navigationDestination(isPresented: $navigateToLogin) {
                StudentLogin(isSignedOut: $isSignedOut)
            }
        }
    }

    var content: some View {
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
                .foregroundColor(Color("#AE0000"))
                .offset(x: 15, y: -170)
            Text("Sign up")
                .font(.custom("Poppins-Regular", size: 50))
                .offset(x: -60, y: -100)
            Text("Enter your email address")
                .offset(x: -60, y: -20)
            Text("Enter your password")
                .offset(x: -70, y: 90)
            
            TextField("Username or email address", text: $email)
                .foregroundColor(.gray)
                .bold()
                .frame(maxWidth: 288, maxHeight: 55)
                .background(Color.white)
                .cornerRadius(10.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .offset(x: -3, y: 28)
                .padding(.horizontal)
                .padding(.vertical, 5)
            
            SecureField("Password", text: $password)
                .foregroundColor(.gray)
                .bold()
                .frame(maxWidth: 288, maxHeight: 55)
                .background(Color.white)
                .cornerRadius(10.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .offset(x: -3, y: 143)
                .padding(.horizontal)
                .padding(.vertical, 5)
            
            Button(action: signUpButton) {
                Text("Sign up")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: 280)
                    .frame(maxHeight: 50)
            }
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(LinearGradient(colors: [Color(red: 0.7, green: 0, blue: 0), Color(red: 0.7, green: 0, blue: 0)], startPoint: .top, endPoint: .bottomTrailing))
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
            }
        )
    }

    func signUp(email: String, password: String) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            isLoading = false
            if let error = error {
                // An error occurred while signing up
                errorMessage = error.localizedDescription
                showErrorAlert = true
                print("Error signing up:", error.localizedDescription)
            } else {
                // Sign-up successful
                print("Sign up successful!")
                navigateToLogin = true // Set navigateToLogin to true to trigger NavigationLink
            }
        }
    }

    func signUpButton() {
        signUp(email: email, password: password)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isSignedOut: .constant(true))
    }
}

import SwiftUI
import Firebase

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.hasPrefix("#") ? hex.index(after: hex.startIndex) : hex.startIndex

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

struct StudentLogin: View {
    @Binding var isSignedOut: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    @State private var errorMessage = ""
    @State private var showErrorAlert = false
    @State private var isLoading = false
    @AppStorage("log_Status") var log_Status = false
    @State private var isAdmin = false

    var body: some View {
        NavigationStack {
            ZStack {
                if userIsLoggedIn {
                    if isAdmin {
                        AdminTabBarView(isSignedOut: $isSignedOut) // Navigate to AdminTabBarView if admin
                    } else {
                        TabBarView(isSignedOut: $isSignedOut) // Otherwise, navigate to TabBarView
                    }
                } else {
                    content
                        .alert(isPresented: $showErrorAlert) {
                            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                        }
                }
                if isLoading {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()

                    ProgressView()
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
                .foregroundColor(Color(hex: "#AE0000"))
                .offset(x: 15, y: -170)
            Text("Sign in")
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

            Button {
                login()
                isSignedOut = false
            } label: {
                Text("Sign in")
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

            Text("Don't have an account yet?")
                .offset(x: -30, y: 290)

            NavigationLink(destination: SignUpView(isSignedOut: $isSignedOut)) {
                Text("Sign up")
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .frame(maxWidth: 280)
                    .frame(maxHeight: 50)
            }
            .offset(x: 110, y: 290)
        }
        .offset(y: 0)
    }

    func login() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
                showErrorAlert = true
                print(error.localizedDescription)
            } else {
                if let user = Auth.auth().currentUser {
                    checkIfAdmin(userID: user.uid) { isAdmin in
                        self.isAdmin = isAdmin
                        self.userIsLoggedIn = true
                        print("User ID: \(user.uid), Is Admin: \(isAdmin)")
                    }
                }
            }
        }
    }

    func checkIfAdmin(userID: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("Admin").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

struct StudentLogin_Previews: PreviewProvider {
    static var previews: some View {
        StudentLogin(isSignedOut: .constant(true))
    }
}

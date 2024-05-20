import SwiftUI
import Firebase

extension Color {
    init(hex: String) {
        var hex = hex
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }

        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

struct StudentLogin: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    @State private var errorMessage = ""
    @State private var showErrorAlert = false
    @State private var isLoading = false
    @AppStorage("log_Status") var log_Status = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if userIsLoggedIn {
                    TabBarView() // Present TabBarView() if user is logged in
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
            Text("Enter your email adress")
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
            } label: {
                Text("Sign in")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: 280)
                    .frame(maxHeight: 50)
            }
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.linearGradient(colors: [Color(red: 0.7, green: 0, blue: 0), Color(red: 0.7, green: 0, blue: 0)], startPoint: .top, endPoint: .bottomTrailing))
            )
            .offset(y: 240)
            
            Text("Don't have an account yet?")
                .offset(x: -30, y: 290)
            
            NavigationLink(destination: SignUpView()) {
                Text("Sign up")
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .frame(maxWidth: 280)
                    .frame(maxHeight: 50)
            }
            .offset(x: 110, y: 290)
        }
        .offset(y: -50)
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
                userIsLoggedIn = true
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

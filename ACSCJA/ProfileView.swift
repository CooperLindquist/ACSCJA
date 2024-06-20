import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileView: View {
    @StateObject var viewModel = ActivityViewModel()

    @State private var showingActivitySelection = false
    @State private var showingNamePrompt = false
    @State private var showingChangePassword = false
    @State private var userName: String = ""
    @State private var userID: String = ""
    @State private var isSignedOut = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("HomePageBackground")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Your Profile")
                        .font(.system(size: 40))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.top, 50)

                    Text("Settings")
                        .foregroundColor(.white)
                        .padding(.top, 20)

                    Button(action: {
                        showingNamePrompt = true
                    }) {
                        Text("Change name")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(10.0)
                            .background(
                                Rectangle()
                                    .fill(Color.white)
                                    .opacity(0.4)
                                    .cornerRadius(10)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)

                    Button(action: {
                        showingChangePassword = true
                    }) {
                        Text("Change Password")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(10.0)
                            .background(
                                Rectangle()
                                    .fill(Color.white)
                                    .opacity(0.4)
                                    .cornerRadius(10)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .sheet(isPresented: $showingChangePassword) {
                        ChangePasswordView(isPresented: $showingChangePassword)
                    }

                    Button(action: {
                        signOut()
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(10.0)
                            .background(
                                Rectangle()
                                    .fill(Color.white)
                                    .opacity(0.4)
                                    .cornerRadius(10)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
                .background(
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 800)
                )
            }
            .onAppear {
                if let user = Auth.auth().currentUser {
                    userID = user.uid
                    viewModel.userID = userID
                    viewModel.getAvailableSports()
                }
            }
            .sheet(isPresented: $showingNamePrompt) {
                NamePromptView(userName: $userName, showingNamePrompt: $showingNamePrompt, userID: userID)
            }
            .navigationDestination(isPresented: $isSignedOut) {
                Start()
            }
        }
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedOut = true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

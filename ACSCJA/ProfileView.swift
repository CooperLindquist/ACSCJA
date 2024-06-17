import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileView: View {
    @StateObject var viewModel = ActivityViewModel()
    
    @State private var showingActivitySelection = false
    @State private var showingNamePrompt = false
    @State private var userName: String = ""
    @AppStorage("userName") private var storedUserName: String = ""
    
    @State private var userID: String = ""
    @State private var isSignedOut = false // State variable to manage navigation

    var body: some View {
        NavigationStack {
            ZStack {
                Image("HomePageBackground")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Button {
                        showingActivitySelection = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showingActivitySelection) {
                        ActivitySelectionView(activities: viewModel.availableSports) { selectedActivity in
                            viewModel.addFollowedActivity(selectedActivity)
                            showingActivitySelection = false
                        }
                    }
                    
                    Text("Your Profile")
                        .font(.system(size: 40))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    Text("Followed Activities")
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            if viewModel.FollowedActivities.isEmpty {
                                Text("You don't follow any activities!")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        Rectangle()
                                            .fill(Color.black)
                                            .opacity(0.4)
                                            .cornerRadius(10)
                                    )
                            } else {
                                ForEach(viewModel.FollowedActivities, id: \.self) { item in
                                    HStack {
                                        Text(item)
                                            .foregroundColor(.white)
                                            .padding(10.0)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .opacity(0.4)
                                                    .cornerRadius(10)
                                                    .padding(.vertical, 2)
                                            )
                                        Button(action: {
                                            viewModel.removeFollowedActivity(item)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                        .padding(.trailing, 10)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    
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
                )
            }
            .onAppear {
                if let user = Auth.auth().currentUser {
                    userID = user.uid
                    viewModel.userID = userID
                    viewModel.getFollowedActivities()
                    viewModel.getAvailableSports()
                }
            }
            .sheet(isPresented: $showingNamePrompt) {
                NamePromptView(userName: $userName, storedUserName: $storedUserName, showingNamePrompt: $showingNamePrompt, userID: userID)
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

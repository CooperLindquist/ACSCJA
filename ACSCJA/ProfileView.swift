import SwiftUI
import FirebaseAuth
import PhotosUI

struct ProfileView: View {
    @StateObject var activityViewModel = ActivityViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @State private var showingActivitySelection = false
    @State private var showingNamePrompt = false
    @State private var showingChangePassword = false
    @State private var showingImagePicker = false
    @State private var userName: String = ""
    @State private var userID: String = ""
    @State private var isSignedOut = false
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationStack {
            ScrollView {
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
                        
                        if let profileImage = profileViewModel.profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                                .onTapGesture {
                                    showingImagePicker = true
                                }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                                .onTapGesture {
                                    showingImagePicker = true
                                }
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
                        
                        Text("Followed Activities")
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        List {
                            ForEach(activityViewModel.followedSports, id: \.self) { sport in
                                HStack {
                                    Image(sport)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40.0)
                                    Text(sport)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Button(action: {
                                        activityViewModel.unfollowSport(sport)
                                    }) {
                                        Text("Unfollow")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                        .frame(height: 200)
                        .background(Color.clear)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        
                        Button(action: {
                            showingActivitySelection = true
                        }) {
                            Text("Follow a new sport")
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
                        .sheet(isPresented: $showingActivitySelection) {
                            ActivitySelectionView(viewModel: activityViewModel, onSportFollowed: { sport in
                                showingActivitySelection = false
                            })
                        }
                    }
                    .padding(.horizontal)
                    .background(
                        Rectangle()
                            .fill(Color.black.opacity(0.5))
                            .edgesIgnoringSafeArea(.all)
                            .frame(height: 1200)
                    )
                }
            }
            .onAppear {
                if let user = Auth.auth().currentUser {
                    userID = user.uid
                    activityViewModel.userID = userID
                    activityViewModel.getAvailableSports()
                    activityViewModel.getFollowedSports()
                    profileViewModel.userID = userID
                    profileViewModel.fetchProfileImage()
                }
            }
            .sheet(isPresented: $showingNamePrompt) {
                NamePromptView(userName: $userName, showingNamePrompt: $showingNamePrompt, userID: userID)
            }
            .navigationDestination(isPresented: $isSignedOut) {
                Start()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .onChange(of: selectedImage) { newImage in
                if let newImage = newImage {
                    profileViewModel.uploadProfileImage(newImage) { result in
                        switch result {
                        case .success(let url):
                            print("Profile image uploaded: \(url)")
                            profileViewModel.fetchProfileImage()
                        case .failure(let error):
                            print("Error uploading profile image: \(error.localizedDescription)")
                        }
                    }
                }
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

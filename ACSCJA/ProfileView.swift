import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @ObservedObject var viewModel = ActivityViewModel()
    @Binding var isSignedOut: Bool
    @State private var showingActivitySelection = false
    let activities: [String] = ["Baseball", "Football", "Soccer"]
    
    var body: some View {
        if isSignedOut {
            StudentLogin()
        } else {
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
                        ActivitySelectionView(activities: activities) { selectedActivity in
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
                            if viewModel.followedActivities.isEmpty {
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
                                ForEach(viewModel.followedActivities, id: \.self) { item in
                                    Text(item)
                                        .foregroundColor(.white)
                                        .padding(10.0)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            Rectangle()
                                                .fill(Color.white)
                                                .opacity(0.4)
                                                .cornerRadius(10)
                                                .padding(.vertical, 2)
                                        )
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Text("Settings")
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    Button(action: {
                        // Add action for changing name
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
                viewModel.getFollowedActivities()
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
        ProfileView(isSignedOut: .constant(true))
    }
}

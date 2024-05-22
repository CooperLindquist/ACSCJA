import SwiftUI
import Firebase

struct ProfileView: View {
    @State private var showActivitySelection = false
    @State private var followedActivities: [String] = []
    @State private var userID: String? = Auth.auth().currentUser?.uid
    @State private var refreshView = false // Add a state property to refresh the view
    
    let activities: [String] = ["Baseball", "Basketball", "Soccer"]
    
    var body: some View {
        ZStack {
            Image("HomePageBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Button(action: {
                    showActivitySelection = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
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
                        if followedActivities.isEmpty {
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
                            ForEach(followedActivities, id: \.self) { activity in
                                Text(activity)
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
            }
            .padding(.horizontal)
            .background(
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .onAppear {
            // Fetch followed activities when view appears
            fetchFollowedActivities()
        }
        .sheet(isPresented: $showActivitySelection) {
            ActivitySelectionView(activities: activities, onActivitySelected: { activity in
                saveActivity(activity: activity)
                showActivitySelection = false
            })
        }
        .onChange(of: refreshView) { _ in
            // Triggered when refreshView changes, fetch followed activities again
            fetchFollowedActivities()
        }
    }
    
    private func fetchFollowedActivities() {
        guard let userID = userID else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data(), let activities = data["followedActivities"] as? [String] {
                    followedActivities = activities
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func saveActivity(activity: String) {
        guard let userID = userID else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).updateData([
            "followedActivities": FieldValue.arrayUnion([activity])
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                // Set refreshView to trigger view update
                refreshView.toggle()
            }
        }
    }
}

struct ActivitySelectionView: View {
    let activities: [String]
    let onActivitySelected: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Select Activity")
                .font(.title)
                .padding()
            
            List(activities, id: \.self) { activity in
                Button(action: {
                    onActivitySelected(activity)
                }) {
                    Text(activity)
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

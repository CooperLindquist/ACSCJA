import SwiftUI
import Firebase
import FirebaseFirestore

struct GroupListView: View {
    @StateObject private var viewModel = ActivityViewModel()
    @State private var selectedSport: String?
    @State private var isMember: Bool?

    var body: some View {
        NavigationStack {
            ZStack {
                // Set the background image
                Image("HomePageBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    Text("Sport Groups")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#AE0000"))
                        .padding(.top, 40)

                    List {
                        ForEach(viewModel.availableSports, id: \.self) { sport in
                            Button(action: {
                                checkMembership(for: sport)
                            }) {
                                HStack {
                                    Image(sport)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40.0)
                                    Text(sport)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: "#000000"))
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .listRowBackground(Color.clear) // Make the list row background clear
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear) // Make the entire list background clear
                }
                .offset(y: 50)
            }
            .navigationTitle("Groups")
            .navigationDestination(isPresented: Binding<Bool>(
                get: { selectedSport != nil },
                set: { isPresented in
                    if !isPresented {
                        selectedSport = nil
                        isMember = nil
                    }
                })) {
                GroupNavigationView(isMember: isMember ?? false, sport: selectedSport ?? "")
            }
        }
        .onAppear {
            viewModel.getAvailableSports()
        }
    }

    private func checkMembership(for sport: String) {
        viewModel.checkMembership(for: sport) { isMember in
            self.isMember = isMember
            self.selectedSport = sport
        }
    }
}

struct GroupNavigationView: View {
    let isMember: Bool
    let sport: String

    var body: some View {
        if isMember {
            MainTabView(sport: sport)
        } else {
            NotAMemberView()
        }
    }
}

struct NotAMemberView: View {
    var body: some View {
        Text("You are not a member")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
            .navigationTitle("Not a Member")
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView()
    }
}

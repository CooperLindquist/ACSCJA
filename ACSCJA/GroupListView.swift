import SwiftUI
import Firebase
import FirebaseFirestore

struct GroupListView: View {
    @StateObject private var viewModel = ActivityViewModel()

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
                            NavigationLink(destination: MainTabView(sport: sport)) {
                                Text(sport)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "#000000"))
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
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
        }
        .onAppear {
            viewModel.getAvailableSports()
        }
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView()
    }
}

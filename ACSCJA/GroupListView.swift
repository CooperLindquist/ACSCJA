import SwiftUI
import Firebase
import FirebaseFirestore

struct GroupListView: View {
    @StateObject private var viewModel = ActivityViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#FFFFFF")
                    .ignoresSafeArea()

                VStack {
                    Text("Sport Groups")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#AE0000"))
                        .padding(.top, 40)

                    List(viewModel.availableSports, id: \.self) { sport in
                        NavigationLink(destination: SportHomeView(sport: sport)) {
                            Text(sport)
                                .foregroundColor(Color(hex: "#000000"))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .listRowBackground(Color(hex: "#FFFFFF"))
                    }
                    .listStyle(PlainListStyle())
                }
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



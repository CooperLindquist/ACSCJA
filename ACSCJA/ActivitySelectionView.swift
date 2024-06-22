
import SwiftUI
import Firebase
import FirebaseAuth
import Foundation



struct ActivitySelectionView: View {
    @ObservedObject var viewModel: ActivityViewModel
    var onSportFollowed: (String) -> Void

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.availableSports, id: \.self) { sport in
                    Button(action: {
                        viewModel.followSport(sport)
                        onSportFollowed(sport)
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
                }
            }
            .navigationBarTitle("Select a Sport", displayMode: .inline)
        }
    }
}


//
//  ArchivedScoreView.swift
//  ACSCJA
//
//  Created by 90310805 on 5/14/24.
//

import SwiftUI

struct ArchivedScoreView: View {
    @ObservedObject var model = ArchivedScoreViewModel()
    @State private var selectedSport: String = "" // Initialize selectedSport
    
    var body: some View {
        ZStack {
            Image("HomePageBackground")
            ScrollView {
                VStack {
                    // Filter model.array to get unique sports
                    let uniqueSports = Array(Set(model.array.map { $0.Sport }))
                    
                    ForEach(uniqueSports.sorted(), id: \.self) { sport in
                        Button(action: {
                            // Set selectedSport to the name of the button clicked
                            selectedSport = sport
                        }) {
                            Text(sport)
                                .foregroundColor(Color.white)
                                .padding(10.0)
                                .frame(maxWidth: 320)
                        }
                    }
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .opacity(0.4)
                            .cornerRadius(10)
                    )
                    
                    // Show documents filtered by selectedSport
                    ForEach(model.array.filter { $0.Sport == selectedSport }, id: \.id) { item in
                        VStack {
                            ZStack {
                                Image("HomePageBox")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350.0)
                                Text("Eden Prairie vs \(item.AwayTeam)")
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .offset(y: -59)
                                HStack {
                                    Image("EP")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 55)
                                    
                                    Text("\(item.EPScore) - \(item.OtherScore)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 30))
                                    if let awayTeamImage = UIImage(named: item.AwayTeam) {
                                        Image(uiImage: awayTeamImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 60)
                                    } else {
                                        Text("No \n Image")
                                    }
                                }
                                .padding(.trailing)
                                HStack {
                                    Text(item.Sport)
                                        .fontWeight(.heavy)
                                        .offset(y: 50)
                                    Text(item.Date)
                                        .fontWeight(.heavy)
                                        .offset(y: 50)
                                }
                            }
                        }
                    }
                }
            }
            .offset(y: 200)
        }
        .onAppear {
            model.getData()
        }
    }
}

struct ArchivedScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ArchivedScoreView()
    }
}

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
    @State private var showFilterOptions: Bool = false // State variable to control filter options visibility
    
    var body: some View {
        ZStack {
            Image("HomePageBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                showFilterOptions.toggle() // Toggle the visibility of filter options
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40.0)
                                .foregroundColor(.white)
                                
                        }
                        .padding(.trailing)
                    }
                    
                    VStack {
                        // Show documents filtered by selectedSport
                        ForEach(model.array.filter { $0.Sport == selectedSport || selectedSport.isEmpty }, id: \.id) { item in
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

                                        Text("\(item.EPScore)")
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.white) // Set explicit color
                                            .font(.system(size: 30))
                                        
                                        Image(item.Sport)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50.0)
                                            
                                        Text("\(item.OtherScore)")
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.white) // Set explicit color
                                            .font(.system(size: 30))
                                        if(item.AwayTeam == "Minnetonka") {
                                            Image(item.AwayTeam)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 40)
                                        }
                                        else {
                                            Image(item.AwayTeam)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 60)
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
                    .padding(.top)
                }
               
            }
            
            // Filter options
            if showFilterOptions {
                VStack {
                    // Filter model.array to get unique sports
                    let uniqueSports = Array(Set(model.array.map { $0.Sport }))
                    
                    ForEach(uniqueSports.sorted(), id: \.self) { sport in
                        Button(action: {
                            withAnimation {
                                selectedSport = sport
                                showFilterOptions = false // Hide filter options when a sport is selected
                            }
                        }) {
                            Text(sport)
                                .foregroundColor(Color.white)
                                .padding(10.0)
                                .frame(maxWidth: 320)
                                .background(
                                    Rectangle()
                                        .fill(Color.white)
                                        .opacity(0.4)
                                        .cornerRadius(10)
                                )
                                .padding(.vertical, 5)
                        }
                    }
                }
                .frame(width: 200)
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
                .padding()
                .transition(.move(edge: .trailing)) // Slide in from the right
                .zIndex(1) // Ensure it appears above other views
            }
        }
        .onAppear {
            model.getData()
        }
        //.navigationBarBackButtonHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    }
}

struct ArchivedScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ArchivedScoreView()
    }
}

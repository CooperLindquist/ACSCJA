//
//  ScoresView.swift
//  ACSCJA
//
//  Created by 90310805 on 4/11/24.
//

import SwiftUI
import Firebase

struct ScoresView: View {
    @ObservedObject var model = ViewModel()
    
    var body: some View {
        
        ZStack {
            Image("HomePageBackground")
            ScrollView {


                VStack {
                      
                        Text("Scores")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .font(.system(size: 45))
                            .padding(.trailing, 180.0)
                        
                           
                    
                   
                    ForEach(model.array.sorted(by: {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        if let date1 = dateFormatter.date(from: $0.Date), let date2 = dateFormatter.date(from: $1.Date) {
                            return date1 < date2
                        }
                        return false
                    }), id: \.id) { item in
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
                                    Image("EPEagle")
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
               .padding(.bottom, 300.0)
            }
            .offset(y: 150)
        }
        .ignoresSafeArea()
        .onAppear {
            model.getData()
        }
    }
}

#if DEBUG
struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresView()
    }
}
#endif

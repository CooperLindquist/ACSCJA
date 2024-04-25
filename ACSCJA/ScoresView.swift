//
//  ScoresView.swift
//  ACSCJA
//
//  Created by 90310805 on 4/11/24.
//

import SwiftUI

struct ScoresView: View {
    let Scores: [String] = ["Minnetonka", "Edina", "Hopkins"]
    let sport: [String] = ["Baseball", "Football", "Basketball"]
    @State var homeScores: [Int] = [10, 20, 15] // Example home scores
    @State var awayScores: [Int] = [0, 7, 10]   // Example away scores
    
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
                    
                    ForEach(Scores.indices, id: \.self) { index in
                        let item = Scores[index]
                        
                        VStack {
                            ZStack {
                                Image("HomePageBox")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350.0)
                                Text("Eden Prairie vs \(item)")
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .offset(y: -59)
                                HStack {
                                    Image("EPEagle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 55)
                                        
                                    Text("\(homeScores[index]) - \(awayScores[index])")
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 30))
                                    Image(item)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 60)
                                }
                                .padding(.trailing)
                                
                            }
                        }
                    }
                }
                .padding(.bottom, 300.0)
            }
            .offset(y: 150)
        }
        .ignoresSafeArea()
    }
}

#if DEBUG
struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresView()
    }
}
#endif

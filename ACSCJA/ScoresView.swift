//
//  ScoresView.swift
//  ACSCJA
//
//  Created by 90310805 on 4/11/24.
//

import SwiftUI

struct ScoresView: View {
    let Scores : [String] = ["Minnetonka", "Edina", "Hopkins"]
    
    
    var body: some View {
        
            ZStack{
                Image("HomePageBackground")
                ScrollView{
                VStack{
                    Text("Scores")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .font(.system(size: 45))
                        .padding(.trailing, 180.0)
                    
                    ForEach(Scores, id: \.self) { item in
                        VStack {
                            ZStack{
                                Image("HomePageBox")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350.0)
                                Text("Eden Prairie vs " + item)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .offset(y: -59)
                                Image("EPEagle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.trailing, 230.0)
                                    .padding(.top)
                                    .frame(height: 60)
                                Text("99 - 0")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 30))
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

#Preview {
    ScoresView()
}

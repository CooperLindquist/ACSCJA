//
//  ScoresView.swift
//  ACSCJA
//
//  Created by 90310805 on 4/11/24.
//

import SwiftUI

struct ScoresView: View {
    var body: some View {
        ScrollView{
            ZStack{
                Image("HomePageBackground")
                VStack{
                    Text("Scores")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .font(.system(size: 45))
                        .padding(.trailing, 180.0)
                    Image("HomePageBox")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350.0)
                    Image("HomePageBox")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350.0)
                    Image("HomePageBox")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350.0)
                        
                    
                }
                .padding(.bottom, 300.0)
            }
        }
        .ignoresSafeArea()

    }
}

#Preview {
    ScoresView()
}

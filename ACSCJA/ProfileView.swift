//
//  ProfileView.swift
//  ACSCJA
//
//  Created by 90310805 on 4/11/24.
//

import SwiftUI

struct ProfileView: View {
    let activity = ["Soccer", "Baseball", "Football"]
    
    
    var body: some View {
        ZStack{
            Image("HomePageBackground")
            VStack{
                Text("Your Profile")
                    .fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .font(.system(size: 40))
                    .padding(.trailing, 100.0)
                Text("Followed Activities")
                    .foregroundColor(Color.white)
                    .padding(.trailing, 180.0)
            }
            
            .offset(y: -300)
                    
            VStack(alignment: .leading) {
                
                
                ForEach(activity, id: \.self) { item in
                    
                        Text(item)
                            .foregroundColor(Color.white)
                            .padding()
                        
                        
                    
                }
                
                .frame(maxWidth: 320)
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .opacity(0.4)
                        .cornerRadius(10)
                    
                    
                )
            }
            .offset(y: -100)
                
                
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

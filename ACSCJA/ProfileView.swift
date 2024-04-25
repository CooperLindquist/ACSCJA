//
//  ProfileView.swift
//  ACSCJA
//
//  Created by 90310805 on 4/11/24.
//

import SwiftUI

struct ProfileView: View {
    let activity : [String] = ["Baseball", "poopy butt", "car"]
    
    
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
            ScrollView {
                VStack(alignment: .leading) {
                    
                    if activity.count == 0 {
                        
                        Text("You don't follow any activities!")
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(maxWidth: 320)
                            .background(
                                Rectangle()
                                    .fill(Color.black)
                                    .opacity(0.4)
                                    .cornerRadius(10))
                        
                    }
                    else {
                        ForEach(activity, id: \.self) { item in
                            
                            Text(item)
                                .foregroundColor(Color.white)
                                .padding(10.0)
                            
                            
                            
                        }
                        
                        .frame(maxWidth: 320)
                        .background(
                            Rectangle()
                                .fill(Color.white)
                                .opacity(0.4)
                                .cornerRadius(10)
                            
                            
                        )
                    }
                    Text("Settings")
                        .foregroundColor(Color.white)
                    Button(action: {
                        
                    }, label: {
                        Text("Change name")
                            .foregroundColor(Color.white)
                            .frame(maxWidth: 300)
                            .padding(10.0)
                            .background(
                                Rectangle()
                                    .fill(Color.white)
                                    .opacity(0.4)
                                    .cornerRadius(10)
                                   
                                )
                    })
                }
                
               
            }
            
            .offset(y: 280)
                
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

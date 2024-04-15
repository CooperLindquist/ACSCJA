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
                VStack {
                    ForEach(activity, id: \.self) { item in
                        Text(item)
                    }
                }
                .frame(maxHeight: 500)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

//
//  AddCalendarView.swift
//  ACSCJA
//
//  Created by 64000270 on 5/15/24.
//

import SwiftUI

struct AddCalendarView: View {
    @State private var name: String = ""
    var body: some View {
        ZStack{
            RadialGradient(gradient: Gradient(colors: [Color("goodRed"), Color("SelectBgr")]), center: UnitPoint(x: 0, y: 0.1), startRadius: 0, endRadius: 1200)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading){
                Text("Add Event")
                    .font(.custom("Poppins-Medium", size: 50))
                    .foregroundColor(.white)
                Text("Name of Event")
                    .font(.custom("Poppins-Medium", size: 15))
                    .foregroundColor(.white)
//                TextField("", text: $name)
//                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    AddCalendarView()
}

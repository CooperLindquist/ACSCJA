//
//  Start.swift
//  ACSCJA
//
//  Created by 90310805 on 3/27/24.
//

import SwiftUI

struct Start: View {
    @State private var showSheet = false
    var body: some View {
        
        ZStack {
            Color.red
                .ignoresSafeArea()
                        
            Image("Start")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal)
                .frame(width: 500.0)
                .ignoresSafeArea()
                
            Button(action: {
                showSheet = true
            }, label: {
                Text("Student")
                
                    .frame(maxWidth: 294)
                    .frame(maxHeight: 55)
                
                    .background()
                    
                   .opacity(0)
                    
            })
            .offset(x: -2, y: 161)
            
        }
        .sheet(isPresented: $showSheet) {
            StudentLogin()
        }
        
        
        
        
    }
    
}

#Preview {
    Start()
}

//
//  ArchivedScoreView.swift
//  ACSCJA
//
//  Created by 90310805 on 5/7/24.
//

import SwiftUI

struct ArchivedScoreView: View {
    @ObservedObject var model = ArchivedScoreViewModel()
    var body: some View {
        ZStack {
            Image("HomePageBackground")
        ScrollView {
                ForEach(model.array.sorted(by: {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    if let date1 = dateFormatter.date(from: $0.Date), let date2 = dateFormatter.date(from: $1.Date) {
                        return date1 < date2
                    }
                    return false
                }), id: \.id) { item in
                    
                    Button(action: {
                        
                    }, label: {
                        Text(item.AwayTeam)
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
        .offset(y:200)
            .onAppear {
                model.getData()
            }
        }
    }
}

#Preview {
    ArchivedScoreView()
}

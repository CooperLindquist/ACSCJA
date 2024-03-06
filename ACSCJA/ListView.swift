//
//  ListView.swift
//  ACSCJA
//
//  Created by 90310805 on 3/25/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        NavigationView {
            List(dataManager.CalendarEvents, id: \.id) { calendarevent in
                Text(calendarevent.time)
            }
            .navigationTitle("Events")
            .navigationBarItems(trailing: Button(action: {
                //add
            }, label: {
                Image(systemName: "plus")
                
            }))
        }
        
    }
}

#Preview {
    ListView()
        .environmentObject(DataManager())
}

//
//  ACSCJAApp.swift
//  ACSCJA
//
//  Created by 90310805 on 3/6/24.
//

import SwiftUI
import Firebase
@main
struct ACSCJAApp: App {
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Start()
                .environmentObject(dataManager)
        }
    }
}

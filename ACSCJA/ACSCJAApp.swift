import SwiftUI

@main
struct ACSCJAApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // State variable to manage sign-out status
    @State private var isSignedOut: Bool = true

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if isSignedOut {
                    Start(isSignedOut: $isSignedOut)
                } else {
                    AdminTabBarView(isSignedOut: $isSignedOut)
                }
            }
        }
    }
}

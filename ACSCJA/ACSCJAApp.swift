import SwiftUI

@main
struct ACSCJAApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                 Start()
            }
        }
    }
}

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

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
                    Start()
                } else {
                    TabBarView(isSignedOut: $isSignedOut)
                }
            }
        }
    }
}

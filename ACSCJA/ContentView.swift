import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isSignedOut = true  // Assume user is initially signed out
    
    var body: some View {
        NavigationStack {
            if isSignedOut {
                StudentLogin(isSignedOut: $isSignedOut)
            } else {
                TabBarView(isSignedOut: $isSignedOut)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

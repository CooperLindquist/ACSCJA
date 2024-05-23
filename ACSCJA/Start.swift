import SwiftUI

struct Start: View {
    @State private var showSheet = false
    @State private var isSignedOut = true  // Add this state variable

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
            StudentLogin(isSignedOut: $isSignedOut)  // Pass the binding here
        }
    }
}

#Preview {
    Start()
}

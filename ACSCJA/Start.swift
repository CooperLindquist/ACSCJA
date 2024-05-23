import SwiftUI

struct Start: View {
    @Binding var isSignedOut: Bool

    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            
            Image("StartBackground")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal)
                .frame(width: 500.0)
                .ignoresSafeArea()
            VStack {
                NavigationLink(destination: StudentLogin(isSignedOut: $isSignedOut)) {
                    Text("Student / Teacher")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: 280)
                        .frame(maxHeight: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(LinearGradient(colors: [Color(red: 0.7, green: 0, blue: 0), Color(red: 0.7, green: 0, blue: 0)], startPoint: .top, endPoint: .bottomTrailing))
                        )
                }
                Spacer()
                    .frame(height: 30.0)
                NavigationLink(destination: ScoresView()) {
                    Text("Guest")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: 280)
                        .frame(maxHeight: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(LinearGradient(colors: [Color(red: 0.7, green: 0, blue: 0), Color(red: 0.7, green: 0, blue: 0)], startPoint: .top, endPoint: .bottomTrailing))
                        )
                }
            }
            .offset(y: 250)
        }
    }
}

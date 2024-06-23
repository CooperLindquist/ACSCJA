import SwiftUI
import Firebase

struct GuestLevelPickerView: View {
    @State private var selectedLevel: String = "Varsity"
    @State private var path = NavigationPath()
    
    let levels = ["Varsity", "JV"]
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Image("HomePageBackground")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Select Level")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    Picker("Select Level", selection: $selectedLevel) {
                        ForEach(levels, id: \.self) { level in
                            Text(level)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Group {
                        if selectedLevel == "Varsity" {
                            ScoresView(path: $path)
                        } else if selectedLevel == "JV" {
                            JVScoresView()
                        }
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: selectedLevel)
                    
                    Spacer()
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "ArchivedScores" {
                    ArchivedScoreView()
                }
            }
        }
    }
}




#if DEBUG
struct GuestLevelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        GuestLevelPickerView()
    }
}
#endif

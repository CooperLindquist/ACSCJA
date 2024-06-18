import SwiftUI

struct GuestLevelPickerView: View {
    @State private var selectedLevel: String = "Varsity"
    
    let levels = ["Varsity", "JV"]
    
    var body: some View {
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
                
                // Display the selected view below the picker
                Group {
                    if selectedLevel == "Varsity" {
                        ScoresView()
                    } else if selectedLevel == "JV" {
                        JVScoresView()
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut, value: selectedLevel)
                
                Spacer()
            }
        }
    }
}



#Preview {
    GuestLevelPickerView()
}

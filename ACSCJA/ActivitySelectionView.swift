import SwiftUI

struct ActivitySelectionView: View {
    let activities: [String]
    var onSelect: (String) -> Void
    
    var body: some View {
        NavigationView {
            List(activities, id: \.self) { activity in
                Button(action: {
                    onSelect(activity)
                }) {
                    Text(activity)
                }
            }
            .navigationTitle("Select Activity")
        }
    }
}

struct ActivitySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySelectionView(activities: ["Baseball", "Football", "Soccer"], onSelect: { _ in })
    }
}

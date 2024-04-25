import SwiftUI
import Firebase

struct DBTest: View {
    @ObservedObject var model = ViewModel.shared // Use shared instance
    var body: some View {
        List(model.list) { item in
            Text("\(item.EPScore)")
        }
    }
    
    init() {
        model.getData()
    }
}

#if DEBUG
struct DBTest_Previews: PreviewProvider {
    static var previews: some View {
        DBTest()
    }
}
#endif

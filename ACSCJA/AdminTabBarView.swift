import SwiftUI

struct AdminTabBarView: View {
    @State var selectedTab: String = "house"
    @State var screen: AnyView = AnyView(HomePageView())
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        VStack {
            NavigationView {
                screen
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
            }
            .onAppear {
                screen = AnyView(HomePageView())
            }
            .navigationBarBackButtonHidden(true)  // Just for extra precaution
            .navigationBarHidden(true)
            
            HStack {
                Spacer()
                tabButton(tab: "house", imageName: "house", filledImageName: "house.fill", width: 35.0)
                Spacer()
                tabButton(tab: "court", imageName: "sportscourt", filledImageName: "sportscourt.fill", width: 40.0)
                Spacer()
                tabButton(tab: "person", imageName: "person", filledImageName: "person.fill", width: 28.0)
                Spacer()
            }
            .frame(height: horizontalSizeClass == .compact ? 60 : 80)
            .padding(.bottom, horizontalSizeClass == .compact ? 0 : 10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 10)
        }
    }
    
    private func tabButton(tab: String, imageName: String, filledImageName: String, width: CGFloat) -> some View {
        Button(action: {
            selectTab(tab)
        }, label: {
            Image(systemName: selectedTab == tab ? filledImageName : imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.black)
                .frame(width: width)
        })
    }
    
    private func selectTab(_ tab: String) {
        selectedTab = tab
        switch tab {
        case "house":
            screen = AnyView(HomePageView())
        case "court":
            screen = AnyView(LevelPickerView())
        case "magnify":
            screen = AnyView(ActivitesView())
        case "person":
            screen = AnyView(ProfileView())
        default:
            screen = AnyView(HomePageView())
        }
    }
}

struct AdminTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AdminTabBarView()
                .previewDevice("iPhone 12")
            AdminTabBarView()
                .previewDevice("iPad Pro (12.9-inch) (5th generation)")
        }
    }
}

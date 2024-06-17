import SwiftUI

struct TabBarView: View {
    @Binding var isSignedOut: Bool
    @State var selectedTab: String = "house"
    @State var screen: AnyView = AnyView(HomePageView())

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
            
            HStack {
                Spacer()
                Button(action: {
                    selectTab("house")
                }, label: {
                    Image(systemName: selectedTab == "house" ? "house.fill" : "house")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.black)
                        .frame(width: 35.0)
                })
                Spacer()
                
                Button(action: {
                    selectTab("calendar")
                }, label: {
                    Image(systemName: selectedTab == "calendar" ? "calendar.circle.fill" : "calendar.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.black)
                        .frame(width: 35.0)
                })
                Spacer()
                Button(action: {
                    selectTab("court")
                }, label: {
                    Image(systemName: selectedTab == "court" ? "sportscourt.fill" : "sportscourt")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.black)
                        .frame(width: 40.0)
                })
                Spacer()
                Button(action: {
                    selectTab("magnify")
                }, label: {
                    Image(systemName: selectedTab == "magnify" ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.black)
                        .frame(width: 33.0)
                })
                Spacer()
                Button(action: {
                    selectTab("person")
                }, label: {
                    Image(systemName: selectedTab == "person" ? "person.fill" : "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.black)
                        .frame(width: 28.0)
                })
                Spacer()
            }
            .frame(height: 80)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 10)
        }
    }
    
    private func selectTab(_ tab: String) {
        selectedTab = tab
        switch tab {
        case "house":
            screen = AnyView(HomePageView())
        case "calendar":
            screen = AnyView(CalendarView())
        case "court":
            screen = AnyView(ScoresView())
        case "magnify":
            screen = AnyView(ActivitesView())
        case "person":
            screen = AnyView(ProfileView())
        default:
            screen = AnyView(HomePageView())
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(isSignedOut: .constant(false))
    }
}

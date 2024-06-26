import SwiftUI

struct MainTabView: View {
    var sport: String
    
    var body: some View {
        TabView {
            NavigationView {
                SportHomeView(sport: sport)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationView {
                CalendarEventView(sport: sport)
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            if (sport == "Baseball") {
                NavigationView {
                    BaseballStatsView()
                }
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
            }
        }
        .accentColor(.red) // Change tab bar selection color if needed
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(sport: "Baseball")
    }
}

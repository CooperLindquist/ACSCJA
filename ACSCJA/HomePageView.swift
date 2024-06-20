import SwiftUI
import Firebase
import FirebaseFirestore

struct HomePageView: View {
    @ObservedObject var model = ViewModel()
    @State private var house = "house.fill"
    @State private var calendar = "calendar"
    @State private var court = "sportscourt"
    @State private var magnify = "magnifyingglass.circle"
    @State private var person = "person"
    @State private var userName: String = ""
    @State private var showingNamePrompt = false
    @State private var isLoading = true
    @State private var userID: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Image("HomePageBackground")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)

                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    ScrollView {
                        Text("Hello, \(userName)!")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 50)
                            .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 20) {
                            Text("Scores at a glance")
                                .foregroundColor(Color.white)
                                .padding(.horizontal)

                            ForEach(model.array.sorted(by: {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM/dd/yyyy"
                                if let date1 = dateFormatter.date(from: $0.Date), let date2 = dateFormatter.date(from: $1.Date) {
                                    return date1 > date2 // Change sorting to descending order
                                }
                                return false
                            }).prefix(1), id: \.id) { item in
                                VStack {
                                    ZStack {
                                        Image("HomePageBox")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(.leading)
                                            .frame(width: 380.0)
                                        Text("Eden Prairie vs \(item.AwayTeam)")
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.center)
                                            .padding(.leading)
                                            .offset(y: -59)
                                        HStack {
                                            Image("EP")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 55)

                                            Text("\(item.EPScore)")
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color.white) // Set explicit color
                                                .font(.system(size: 30))
                                            Image(item.Sport)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50.0)
                                            
                                            Text("\(item.OtherScore)")
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color.white) // Set explicit color
                                                .font(.system(size: 30))
                                            if(item.AwayTeam == "Minnetonka") {
                                                Image(item.AwayTeam)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(height: 40)
                                            } else {
                                                Image(item.AwayTeam)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(height: 60)
                                            }
                                        }
                                        .padding(.trailing)
                                        HStack {
                                            Text(item.Gender)
                                                .fontWeight(.heavy)
                                                .foregroundColor(Color.black) // Set explicit color
                                                .offset(y: 50)
                                            Text(item.Level)
                                                .fontWeight(.heavy)
                                                .foregroundColor(Color.black) // Set explicit color
                                                .offset(y: 50)
                                            Text(item.Sport)
                                                .fontWeight(.heavy)
                                                .foregroundColor(Color.black) // Set explicit color
                                                .offset(y: 50)
                                            Text(item.Date)
                                                .fontWeight(.heavy)
                                                .foregroundColor(Color.black) // Set explicit color
                                                .offset(y: 50)
                                        }
                                    }
                                    .offset(x: 10)
                                }
                            }

                            Text("Upcoming activities")
                                .foregroundColor(Color.white)
                                .padding(.horizontal)

                            CustomWebView(url: URL(string: "https://www.edenpr.org/experience/calendar")!)
                                .frame(height: 600) // Increased height for web view
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)
                    }
                    Rectangle()
                        .frame(width: 390.0, height: 70.0)
                        .foregroundColor(.white)
                        .offset(y: UIScreen.main.bounds.height / 2 - 35)
                }
            }
            .onAppear {
                if let user = Auth.auth().currentUser {
                    userID = user.uid
                    fetchUserName()
                }
                model.getData2()
                print("HomePageView appeared") // Debugging line
            }
            .sheet(isPresented: $showingNamePrompt) {
                NamePromptView(userName: $userName, showingNamePrompt: $showingNamePrompt, userID: userID)
            }
        }
    }

    func changeButton(buttonName: String) {
        house = "house"
        calendar = "calendar"
        court = "sportscourt"
        magnify = "magnifyingglass.circle"
        person = "person"
        switch buttonName {
        case "house": house = "house.fill"
        case "calendar": calendar = "calendar.fill"
        case "court": court = "sportscourt.fill"
        case "magnify": magnify = "magnifyingglass.circle.fill"
        case "person": person = "person.fill"
        default: break
        }
    }

    private func fetchUserName() {
        let db = Firestore.firestore()
        let userRef = db.collection("DisplayName").document(userID)
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user name: \(error.localizedDescription)")
                self.showingNamePrompt = true
                self.isLoading = false
            } else if let document = document, document.exists, let data = document.data(), let name = data["name"] as? String {
                self.userName = name
                self.isLoading = false
            } else {
                self.showingNamePrompt = true
                self.isLoading = false
            }
        }
    }
}

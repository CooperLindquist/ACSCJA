import SwiftUI
import Firebase

struct ScoresView: View {
    @ObservedObject var model = ViewModel()
    @Binding var path: NavigationPath
    @State private var userInput: String = "" // State variable to store user input

    var body: some View {
        NavigationView {
            TabView {
                ZStack {
                    Image("HomePageBackground")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)

                    ScrollView {
                        VStack {
                            HStack {
                                Text("Scores")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white) // Set explicit color
                                    .font(.system(size: 45))
                                    .padding(.trailing, 60.0)
                            }

                            ForEach(model.array.filter { $0.Gender == "Boys" && $0.Level == "Varsity" }.sorted(by: {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MM/dd/yyyy"
                                if let date1 = dateFormatter.date(from: $0.Date), let date2 = dateFormatter.date(from: $1.Date) {
                                    return date1 > date2 // Reverse the sorting order
                                }
                                return false
                            }), id: \.id) { item in
                                VStack {
                                    ZStack {
                                        Image("HomePageBox")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 350.0)
                                        Text("Eden Prairie vs \(item.AwayTeam)")
                                            .foregroundColor(Color.white) // Set explicit color
                                            .multilineTextAlignment(.center)
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
                                }
                            }

                            Text("Want To See Old Scores?")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white) // Set explicit color

                            NavigationLink(value: "ArchivedScores") {
                                Text("Click Here")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue) // Set explicit color
                            }
                        }
                        .padding(.bottom, 300.0)
                    }
                    .refreshable {
                        // Refresh the data
                        model.getData2()
                    }
                }
                .tabItem {
                    Label("Boys", systemImage: "person.fill")
                }
                .onAppear {
                    model.getData2()
                    model.checkAdminStatus() // Ensure admin status is checked on appear
                }

                GirlsScoresView()
                    .tabItem {
                        Label("Girls", systemImage: "person.2.fill")
                    }
            }
        }
    }
}

import SwiftUI
import Firebase
import WebKit

struct HomePageView: View {
    @ObservedObject var model = ViewModel()
    @ObservedObject var amodel = CalendarViewModel()
    @State private var house = "house.fill"
    @State private var calendar = "calendar"
    @State private var court = "sportscourt"
    @State private var magnify = "magnifyingglass.circle"
    @State private var person = "person"
    @State private var userName: String = ""
    @State private var showingNamePrompt = false
    @AppStorage("userName") private var storedUserName: String = ""
    
    // Assume userID is available here
    @AppStorage("userID") private var userID: String = "some_user_id" // Replace with actual user ID retrieval

    var body: some View {
        NavigationView {
            ZStack {
                Image("HomePageBackground")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    Text("Hello, \(storedUserName)!")
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
                                        }
                                        else {
                                            Image(item.AwayTeam)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 60)
                                        }

                                    }
                                    .padding(.trailing)
                                    HStack {
                                        Text(item.Sport)
                                            .fontWeight(.heavy)
                                           
                                            .offset(y: 50)
                                        Text(item.Date)
                                            .fontWeight(.heavy)
                                          
                                            .offset(y: 50)
                                    }
                                }
                                .offset(x: 10)
                            }
                        }
                        
                        Text("Upcoming activities")
                            .foregroundColor(Color.white)
                            .padding(.horizontal)

//                        ForEach(amodel.array.sorted(by: {
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "MM/dd/yyyy"
//                            guard let date1 = dateFormatter.date(from: $0.Date), let date2 = dateFormatter.date(from: $1.Date) else {
//                                return false
//                            }
//                            return date1 < date2
//                        }).prefix(2)) { event in
//                            VStack {
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .fill(Color.white)
//                                        .shadow(radius: 5)
//
//                                    HStack {
//                                        VStack(alignment: .leading, spacing: 10) {
//                                            Text("Activity: " + event.Name)
//                                                .font(.headline)
//                                                .foregroundColor(.black)
//
//                                            Text("Time: \(event.StartTime) - \(event.EndTime)")
//                                                .font(.caption)
//                                                .foregroundColor(.gray)
//
//                                            Text("Description: " + event.Description)
//                                                .font(.caption)
//                                                .foregroundColor(.black)
//                                                .lineLimit(3)
//                                        }
//                                        Image("calendarimage")
//                                            .resizable(capInsets: EdgeInsets())
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(height: 80.0)
//                                    }
//                                    .padding()
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
                        
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
            .onAppear {
                amodel.getData()
                if storedUserName.isEmpty {
                    showingNamePrompt = true
                }
                model.getData2()
                print("HomePageView appeared") // Debugging line
            }
            .sheet(isPresented: $showingNamePrompt) {
                NamePromptView(userName: $userName, storedUserName: $storedUserName, showingNamePrompt: $showingNamePrompt, userID: userID)
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
}
struct HomePageView_Previews: PreviewProvider {
static var previews: some View {
HomePageView()
}
}


import SwiftUI
import Firebase

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
                        .position(x: 190, y: 50)

                    VStack {
                        Text("Scores at a glance")
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.trailing, 200.0)

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
                                        .frame(width: 350.0)
                                    Text("Eden Prairie vs \(item.AwayTeam)")
                                        .foregroundColor(Color.white)
                                        .multilineTextAlignment(.center)
                                        .offset(y: -59)
                                    HStack {
                                        Image("EP")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 55)
                                        
                                        Text("\(item.EPScore) - \(item.OtherScore)")
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 30))
                                        if let awayTeamImage = UIImage(named: item.AwayTeam) {
                                            Image(uiImage: awayTeamImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 60)
                                        } else {
                                            Text("No \n Image")
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
                            }
                        }
                        
                        Text("Upcoming activities")
                            .foregroundColor(Color.white)
                            .padding(.trailing, 200.0)
                        
                        ForEach(amodel.array.sorted(by: {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MM/dd/yyyy"
                            guard let date1 = dateFormatter.date(from: $0.Date), let date2 = dateFormatter.date(from: $1.Date) else {
                                return false
                            }
                            return date1 < date2
                        }).prefix(2)) { event in
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white)
                                        .shadow(radius: 5)
                                    Image("calendarimage")
                                        .resizable(capInsets: EdgeInsets())
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 80.0)
                                        .offset(x: 100)
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Activity: " + event.Name)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                        
                                        
                                        Text("Time: \(event.StartTime) - \(event.EndTime)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Text("Description: " + event.Description)
                                            .font(.caption)
                                            .foregroundColor(.black)
                                            .lineLimit(3)
                                        //                                Image("HomePageBox2")
                                        //                                    .resizable()
                                        //                                    .aspectRatio(contentMode: .fit)
                                        //                                    .frame(width: 350.0)
                                        //                                Text("Activity: " + event.Name)
                                        //                                    .foregroundColor(Color.white)
                                        //                                    .offset(y: -140)
                                        //                                Text("Time: \(event.StartTime) - \(event.EndTime)")
                                        //                                    .foregroundColor(Color.white)
                                        //                                    .offset(y: -120)
                                        //                                Text(event.Description)
                                        //
                                    }
                                    .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                            

    
//
                            }
                            .padding()
                        }
                        

                        
                    }
                    .padding(.top, 50.0)
                }
                Rectangle()
                    .frame(width: 390.0, height: 70.0)
                    .foregroundColor(.white)
                    .offset(y: 385)
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
                NamePromptView(userName: $userName, storedUserName: $storedUserName, showingNamePrompt: $showingNamePrompt)
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

struct NamePromptView: View {
    @Binding var userName: String
    @Binding var storedUserName: String
    @Binding var showingNamePrompt: Bool

    var body: some View {
        VStack {
            Text("Enter your name")
                .font(.title)
                .padding()

            TextField("Name", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                storeUserName()
                showingNamePrompt = false
            }) {
                Text("OK")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    private func storeUserName() {
        // Store the user name in AppStorage for persistence
        storedUserName = userName
        
        // Store the user name in Firebase
        let db = Firestore.firestore()
        db.collection("DisplayNames").addDocument(data: ["name": userName]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(String(describing: userName))")
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}

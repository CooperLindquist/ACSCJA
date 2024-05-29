import SwiftUI
import Firebase

struct HomePageView: View {
    @ObservedObject var model = ViewModel()
    @State private var house = "house"
    @State private var calendar = "calendar"
    @State private var court = "sportscourt"
    @State private var magnify = "magnifyingglass.circle"
    @State private var person = "person"
    @State private var userName: String = ""
    @State private var showingNamePrompt = false
    @AppStorage("userName") private var storedUserName: String = ""

    init() {
        house = "house.fill"
    }

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

                        ForEach(model.filteredScores, id: \.self) { item in
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
                                        Image("EPEagle")
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
                        Image("HomePageBox2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350.0)
                        Image("HomePageBox2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350.0)
                    }
                    .padding(.top, 50.0)
                }
                Rectangle()
                    .frame(width: 390.0, height: 70.0)
                    .foregroundColor(.white)
                    .offset(y: 385)
            }
            .onAppear {
                if storedUserName.isEmpty {
                    showingNamePrompt = true
                }
                model.getData()
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

#Preview {
    HomePageView()
}

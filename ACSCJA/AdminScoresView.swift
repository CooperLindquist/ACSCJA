import SwiftUI
import Firebase

struct AdminScoresView: View {
    @ObservedObject var model = ViewModel()
    @State private var userInput: String = "" // State variable to store user input

    var body: some View {
        NavigationView {
            ZStack {
                Image("HomePageBackground")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack {
                        HStack {
                            Text("Score")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .font(.system(size: 45))
                                .padding(.trailing, 60.0)
                            
                            NavigationLink(destination: AddScoreView()) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color.blue)
                                    .frame(width: 25.0)
                            }
                            .offset(x: 30, y: 0)
                            .padding()
                        }

                        ForEach(model.array.sorted(by: {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MM/dd/yyyy"
                            if let date1 = dateFormatter.date(from: $0.Date), let date2 = dateFormatter.date(from: $1.Date) {
                                return date1 < date2
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

                        Text("Wanna See Old Scores?")
                            .font(.system(size: 20))

                        NavigationLink(destination: ArchivedScoreView()) {
                            Text("Click Here")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom, 300.0)
                }
                .refreshable {
                    // Refresh the data
                    model.getData2()
                }
            }
        }
        .onAppear {
            model.getData2()
        }
    }
}

#if DEBUG
struct AdminScoresView_Previews: PreviewProvider {
    static var previews: some View {
        AdminScoresView()
    }
}
#endif

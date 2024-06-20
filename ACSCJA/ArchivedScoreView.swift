import SwiftUI

struct ArchivedScoreView: View {
    @ObservedObject var model = ArchivedScoreViewModel()
    @State private var selectedSport: String = "" // Initialize selectedSport
    @State private var selectedLevel: String = "Varsity" // Initialize selectedLevel
    @State private var selectedGender: String = "Boys" // Initialize selectedGender
    @State private var showFilterOptions: Bool = false // State variable to control filter options visibility
    
    var body: some View {
        ZStack {
            Image("HomePageBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                showFilterOptions.toggle() // Toggle the visibility of filter options
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40.0)
                                .foregroundColor(.white)
                                
                        }
                        .padding(.trailing)
                    }
                    
                    VStack {
                        // Level Picker
                        Picker("Select Level", selection: $selectedLevel) {
                            Text("Varsity").tag("Varsity")
                            Text("JV").tag("JV")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Gender Picker
                        Picker("Select Gender", selection: $selectedGender) {
                            Text("Boys").tag("Boys")
                            Text("Girls").tag("Girls")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Show documents filtered by selectedSport, selectedLevel, and selectedGender
                        ForEach(model.array.filter {
                            $0.Gender == selectedGender && $0.Level == selectedLevel && (selectedSport.isEmpty || $0.Sport == selectedSport)
                        }.sorted(by: {
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
                                        .foregroundColor(Color.white)
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
                    }
                    .padding(.top)
                }
            }
            
            // Filter options
            if showFilterOptions {
                VStack {
                    // Filter model.array to get unique sports
                    let uniqueSports = Array(Set(model.array.map { $0.Sport }))
                    
                    ForEach(uniqueSports.sorted(), id: \.self) { sport in
                        Button(action: {
                            withAnimation {
                                selectedSport = sport
                                showFilterOptions = false // Hide filter options when a sport is selected
                            }
                        }) {
                            Text(sport)
                                .foregroundColor(Color.white)
                                .padding(10.0)
                                .frame(maxWidth: 320)
                                .background(
                                    Rectangle()
                                        .fill(Color.white)
                                        .opacity(0.4)
                                        .cornerRadius(10)
                                )
                                .padding(.vertical, 5)
                        }
                    }
                }
                .frame(width: 200)
                .background(Color.black.opacity(0.6))
                .cornerRadius(10)
                .padding()
                .transition(.move(edge: .trailing)) // Slide in from the right
                .zIndex(1) // Ensure it appears above other views
            }
        }
        .onAppear {
            model.getData()
        }
        //.navigationBarBackButtonHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
    }
}

struct ArchivedScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ArchivedScoreView()
    }
}

//
//  HomePageView.swift
//  ACSCJA
//
//  Created by 90310805 on 4/10/24.
//

import SwiftUI
struct HomePageView: View {
    @ObservedObject var model = ViewModel()
    @State var house = "house"
    @State var calendar = "calendar"
    @State var court = "sportscourt"
    @State var magnify = "magnifyingglass.circle"
    @State var person = "person"
    @State var sport = "Baseball"
   
    
    init() {
        house = "house.fill"
    }
    var body: some View {
        NavigationView {
            ZStack{
                Image("HomePageBackground")
                
                ScrollView {
                    Text("Hello, USER!")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.leading)
                        .position(x: 190, y: 200)
                    
                    VStack{
                        Text("Scores at a glance")
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.trailing, 200.0)
                        
//                        Image("HomePageBox")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 350.0)
                        
                        ForEach(model.array.filter { $0.Sport == sport }, id: \.self) { item in
                            // Your view code for displaying each item
                        

                           
                        
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
                    .padding(.top, 250.0)
                }
                Rectangle()
                    .frame(width: 390.0, height: 70.0)
                    .foregroundColor(.white)
                    .offset(y: 385)
                
                .frame(maxWidth: 400)
                .offset(y: 380)
                
                
            }
            .frame(width: 10.0)
        }
        .onAppear {
            model.getData()
        }
    }
    func changeButton(buttonName: String) {
        let str = buttonName
        house = "house"
        calendar = "calendar"
        court = "sportscourt"
        magnify = "magnifyingglass.circle"
        person = "person"
        if str == "house" {
            house = "house.fill"
        }
        else if str == "calendar" {
            calendar = "calendar.fill"
        }
        else if str == "court" {
            court = "sportscourt.fill"
        }
        else if str == "magnify" {
            magnify = "magnifyingglass.circle.fill"
        }
        else if str == "person" {
            person = "person.fill"
        }
        
       
        
    }
}


#Preview {
    HomePageView()
}

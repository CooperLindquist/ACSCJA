//
//  HomePageView.swift
//  ACSCJA
//
//  Created by 90310805 on 4/10/24.
//

import SwiftUI

struct HomePageView: View {
    @State var house = "house"
    @State var calendar = "calendar"
    @State var court = "sportscourt"
    @State var magnify = "magnifyingglass.circle"
    @State var person = "person"
    
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
                        
                        Image("HomePageBox")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350.0)
                        
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
                HStack{
                    Spacer()
                    Button(action: {
                        changeButton(buttonName: "house")
                    }, label: {
                        Image(systemName: house)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 35.0)
                    })
                    Spacer()
                    
                    Button(action: {
                        changeButton(buttonName: "calendar")
                        
                        
                    }, label: {
                        Image(systemName: calendar)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 35.0)
                    })
                    Spacer()
                    Button(action: {
                        changeButton(buttonName: "court")
                    }, label: {
                        Image(systemName: court)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 40.0)
                    })
                    Spacer()
                    Button(action: {
                        changeButton(buttonName: "magnify")
                    }, label: {
                        Image(systemName: magnify)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 33.0)
                    })
                    Spacer()
                    Button(action: {
                        changeButton(buttonName: "person")
                    }, label: {
                        Image(systemName: person)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.black)
                            .frame(width: 28.0)
                    })
                    Spacer()
                    
                }
                .frame(maxWidth: 400)
                .offset(y: 380)
                
                
            }
            .frame(width: 10.0)
        }
    }
    func changeButton(buttonName: String) {
        var str = buttonName
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

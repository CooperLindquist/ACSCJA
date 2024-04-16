//
//  TabBarView.swift
//  ACSCJA
//
//  Created by 90310805 on 4/11/24.
//

import SwiftUI


struct TabBarView: View {
    @State var house = "house.fill"
    @State var calendar = "calendar"
    @State var court = "sportscourt"
    @State var magnify = "magnifyingglass.circle"
    @State var person = "person"
    @State var screen: AnyView = AnyView(HomePageView())
    
    
    init() {
        house = "house.fill"
    }
    
    var body: some View {
        VStack{
            NavigationView {
                screen
                
                
            }
            .navigationBarBackButtonHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        }
        .padding(.bottom, -49.0)
        
        VStack{
            ZStack{
                Rectangle()
                    .frame(width: 400.0, height: 80.0)
                    .foregroundColor(.white)
                    .offset(y: -94)
                HStack{
                    Spacer()
                    Button(action: {
                        changeButton(buttonName: "house")
                        screen = AnyView(HomePageView())
                        
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
                        screen = AnyView(CalendarView())
                        
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
                        screen = AnyView(ScoresView())
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
                        screen = AnyView(ActivitesView())
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
                        screen = AnyView(ProfileView())
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
                .offset(y: -100)
                
                
            }
            .frame(width: 10.0)
            .offset(y: 135)
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
    TabBarView()
}

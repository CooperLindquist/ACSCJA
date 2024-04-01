//
//  CalendarView.swift
//  ACSCJA
//
//  Created by 64000270 on 4/1/24.
//

import SwiftUI

struct CalendarView: View {
    @State var dateSelected = 0
    @State var time = 8
    @State var temp = ""
//    var mar28schedule : [String] {
//        Array(repeating: "", count: 24)
//    }
//    @State var mar28schedule = ["", "", "", "", "", "", "", "", "", "", "", "", "Super awesome soccer game", "", "", "Football game", "Banana race", "", "", "", "", "", "", ""]
    @State var mar28schedule = [["super awesome soccer game", "12", "14"], ["football game", "15", "17"], ["badminton battle", "16", "19"]]
    @State var times = []
    var body: some View {
        
        VStack{
            HStack{
                
                Button(action: {
                    dateSelected = 1
                }, label: {
                    VStack{
                        Text("S")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("22")
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(.red)
                            .padding(.bottom, 12)
                            .frame(width: 45, height: 25)
                    }
                    
                    .background(dateSelected == 1 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 2
                }, label: {
                    VStack{
                        Text("M")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("23")
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(.red)
                            .padding(.bottom, 12)
                            .frame(width: 45, height: 25)
                    }
                    
                    .background(dateSelected == 2 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 3
                }, label: {
                    VStack{
                        Text("T")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("24")
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(.red)
                            .padding(.bottom, 12)
                            .frame(width: 45, height: 25)
                    }
                    
                    .background(dateSelected == 3 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 4
                }, label: {
                    VStack{
                        Text("W")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("25")
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(.red)
                            .padding(.bottom, 12)
                            .frame(width: 45, height: 25)
                    }
                    
                    .background(dateSelected == 4 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 5
                }, label: {
                    VStack{
                        Text("T")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("26")
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(.red)
                            .padding(.bottom, 12)
                            .frame(width: 45, height: 25)
                    }
                    
                    .background(dateSelected == 5 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 6
                }, label: {
                    VStack{
                        Text("F")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("27")
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(.red)
                            .padding(.bottom, 12)
                            .frame(width: 45, height: 25)
                    }
                    
                    .background(dateSelected == 6 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 7
                }, label: {
                    VStack{
                        Text("S")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("28")
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundColor(.red)
                            .padding(.bottom, 12)
                            .frame(width: 45, height: 25)
                    }
                    
                    .background(dateSelected == 7 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
            }
            Divider()
            HStack{
                ScrollView{
                    VStack{
                        Text("Time")
                        ForEach(0...mar28schedule.count-1, id: \.self) { ind in
                            let startTime = Int(mar28schedule[ind][1])
                            let endTime = Int(mar28schedule[ind][2])
                        }
                       
                    }
                    .font(.custom("Poppins", size: 15))
                }
            }
        }
        
    }
    
}

#Preview {
    CalendarView()
}

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
    @State var mar28schedule = [["super awesome soccer game", "12", "14"], ["football game", "15", "17"], ["badminton battle", "16", "19"], ["Car", "18", "20"]]
    @State var times = []
    //@State var positions: [Int] = []
//    init() {
//            _positions = State(initialValue: position(list: mar28schedule))
//        // Initialize positions array with result of position function
//        }
    
    
    var body: some View {
        
        VStack{
            HStack{
                Button(action: {
                    dateSelected = 1

                }, label: {
                    VStack{
                        Text("S")
                            .font(.custom("Popppins-Regular", size: 15))
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("22")
                            .font(.custom("Poppins-Bold", size: 15))
                            .foregroundColor(.red)
                            .padding(.bottom, 12)
                            .frame(width: 45, height: 25)
                    }
                    
                    
                })
                .background(dateSelected == 1 ? Color("SelectBgr") : .white)
                .cornerRadius(15)
                
                Button(action: {
                    print("poop")
                    dateSelected = 2
                }, label: {
                    VStack{
                        Text("M")
                            .font(.custom("Popppins-Regular", size: 15))
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("23")
                            .font(.custom("Poppins-Bold", size: 15))
                            .fontWeight(.black)
                            .foregroundColor(.red)
                            .padding(.bottom, 12)
                            .frame(width: 45, height: 25)
                    }
                    
                    
                })
                .background(dateSelected == 2 ? Color("SelectBgr") : .white)
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 3
                }, label: {
                    VStack{
                        Text("T")
                            .font(.custom("Popppins-Regular", size: 15))
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("24")
                            .font(.custom("Poppins-Bold", size: 15))
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
                            .font(.custom("Popppins-Regular", size: 15))
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("25")
                            .font(.custom("Poppins-Bold", size: 15))
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
                            .font(.custom("Popppins-Regular", size: 15))
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("26")
                            .font(.custom("Poppins-Bold", size: 15))
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
                            .font(.custom("Popppins-Regular", size: 15))
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("27")
                            .font(.custom("Poppins-Bold", size: 15))
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
                            .font(.custom("Popppins-Regular", size: 15))
                            .foregroundColor(.black)
                            .padding(.top, 12)
                            .frame(width: 45, height: 25)
                        
                        Text("28")
                            .font(.custom("Poppins-Bold", size: 15))
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
            ScrollView{
            HStack{
                Spacer()
                Spacer()
                    VStack{
                        Text("Time")
                            .font(.custom("Poppins-Regular", size: 17))
                        ForEach(0...23, id: \.self) { index in
                            Text(String(index) + ":00")
                                .font(.custom("Poppins-Regular", size: 17))
                                .padding(.bottom, 7.0)
                        }
                    }
//                    .onAppear{
//                        positions = position(list : mar28schedule)
//                        print(positions[1] * 2)
//                    }
                Spacer()
                Spacer()
                Divider()
                ZStack{
                    Text("Event")
                        .font(.custom("Poppins-Regular", size: 17))
                        .position(x: 25, y: 12)
                    ForEach(0..<mar28schedule.count, id: \.self) {index in
                        Button {
                            //New screen for information
                        } label: {
                            Text(mar28schedule[index][0])
                                .font(.custom("Poppins-Regular", size: 16))
                                .foregroundColor(Color.black)
                                .frame(width: 140.0, height: 110.0)
                            
                        }
                        .background(Color("SelectBgr"))
                        .cornerRadius(10)
                        .position(x: 75 + 150 * CGFloat(position(list : mar28schedule, index : index)), y: CGFloat((mar28schedule[index][1] as NSString) .integerValue * 40 + 70))
                    }
                    }
                }
            }
        }
        
    }
    func position(list : [[String]], index : Int) -> Int{
        var fin = 0
        let startTime = (list[index][1] as NSString).integerValue
        for i in 0..<index {
            if startTime >= (list[i][1] as NSString).integerValue && startTime <= (list[i][2] as NSString).integerValue{
                fin += 1
            }
        }
        return fin
    }
}


#Preview {
    CalendarView()
}


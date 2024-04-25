//
//  CalendarView.swift
//  ACSCJA
//
//  Created by 64000270 on 4/1/24.
//

import SwiftUI


struct CalendarView: View {
    @State var dateSelected = 1
    @State var time = 8
    @State var temp = ""
    @State var calIndex = 0
    @State var schedule = [[["super awesome soccer game", "2", "7"], ["football game", "5", "14"], ["badminton battle", "6", "12"], ["Car", "8", "11"],["Craziest Event in all of history", "10", "13"], ["giant", "12", "12"], ["IDEK", "13", "14"]],
                           
       [["Swimming and such", "3", "6"], ["car game", "5", "18"], ["UnderWater basket Weaving", "9", "10"], ["Car", "10", "15"], ["bean stock", "12", "12"], ["IDEK", "15", "20"]],
                           
        [["super awesome soccer game", "2", "7"], ["football game", "5", "14"], ["badminton battle", "6", "12"], ["Car", "8", "11"],["Craziest Event in all of history", "10", "13"], ["giant", "12", "12"], ["IDEK", "13", "14"]],
                           
        [["Swimming and such", "3", "6"], ["car game", "5", "18"], ["UnderWater basket Weaving", "9", "10"], ["Car", "10", "15"], ["bean stock", "12", "12"], ["IDEK", "15", "20"]],
                           
        [["super awesome soccer game", "2", "7"], ["football game", "5", "14"], ["badminton battle", "6", "12"], ["Car", "8", "11"],["Craziest Event in all of history", "10", "13"], ["giant", "12", "12"], ["IDEK", "13", "14"]],
                                              
        [["Swimming and such", "3", "6"], ["car game", "5", "18"], ["UnderWater basket Weaving", "9", "10"], ["Car", "10", "15"], ["bean stock", "12", "12"], ["IDEK", "15", "20"]],
    
        [["super awesome soccer game", "2", "7"], ["football game", "5", "14"], ["badminton battle", "6", "12"], ["Car", "8", "11"],["Craziest Event in all of history", "10", "13"], ["giant", "12", "12"], ["IDEK", "13", "14"]]]
    @State var times = []
    @State var positional: [[Int]] = [[]]
    
    
    var body: some View {
        
        VStack{
            HStack{
                Button(action: {
                    dateSelected = 0
                    calIndex = 0
                    positional = findPos(list : schedule[dateSelected])
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
                .background(dateSelected == 0 ? Color("SelectBgr") : .white)
                .cornerRadius(15)
                
                Button(action: {
                    print("poop")
                    dateSelected = 1
                    calIndex = 1
                    positional = findPos(list : schedule[dateSelected])
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
                .background(dateSelected == 1 ? Color("SelectBgr") : .white)
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 2
                    calIndex = 2
                    positional = findPos(list : schedule[dateSelected])
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
                    
                    .background(dateSelected == 2 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 3
                    calIndex = 3
                    positional = findPos(list : schedule[dateSelected])
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
                    
                    .background(dateSelected == 3 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 4
                    calIndex = 4
                    positional = findPos(list : schedule[dateSelected])
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
                    
                    .background(dateSelected == 4 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 5
                    calIndex = 5
                    positional = findPos(list : schedule[dateSelected])
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
                    
                    .background(dateSelected == 5 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
                
                Button(action: {
                    dateSelected = 6
                    calIndex = 6
                    positional = findPos(list : schedule[dateSelected])
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
                    
                    .background(dateSelected == 6 ? Color("SelectBgr") : .white)
                })
                
                .cornerRadius(15)
            }
            Divider()
            ScrollView(){
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
                                        .onAppear{
                                            positional = findPos(list : schedule[dateSelected])
                                        }
                    Spacer()
                    Spacer()
                    Divider()
                    ScrollView(.horizontal){
                        ZStack{
                            Text("Event")
                                .font(.custom("Poppins-Regular", size: 17))
                                .position(x: 25, y: 12)
                            ForEach(0..<schedule[dateSelected].count, id: \.self) {index in
                                Button {
                                    //New screen for information
                                } label: {
                                    Text(schedule[dateSelected][index][0])
                                        .font(.custom("Poppins-Regular", size: 16))
                                        .foregroundColor(Color.black)
                                        .frame(width: 140.0, height: 32 + 40 * CGFloat(diff(list : schedule[dateSelected], x : index)))
                                    
                                }
                                .background(Color("SelectBgr"))
                                .cornerRadius(10)
                                .position(x: 75 + 150 * CGFloat(pickPos(positions : positional, x : index)), y: CGFloat(sumOf(list : schedule[dateSelected], x : index) * 20 + 33))
                            }
                        }
                        .frame(width: 1000)
                        //your fucntion sucks make so like lists and like if you can put it there put it there
                    }
                }
            }
        }
    }
 
func diff(list : [[String]], x : Int) -> Int{
    let first = (list[x][1] as NSString).integerValue
    let next = (list[x][2] as NSString).integerValue
    return abs(first - next)
}
func sumOf(list : [[String]], x : Int) -> Int{
    let first = (list[x][1] as NSString).integerValue
    let next = (list[x][2] as NSString).integerValue
    return first + next
}
   
}
func findPos(list : [[String]]) -> [[Int]] {
    var fin: [[Int]] = [[]]
    for x in 0..<list.count{
        let startTime = (list[x][1] as NSString).integerValue
        print(startTime)
        fin = placed(list : list, fin : fin, startTime : startTime, x : x)
        
    }
    print (fin)
    return fin
}
func placed(list : [[String]], fin : [[Int]], startTime : Int, x : Int) -> [[Int]]{
    var temp = fin
    for i in 0..<fin.count {
        var fits = true
        for j in 0..<fin[i].count{
            print(i)
            print(j)
            let startTemp = (list[fin[i][j]][1] as NSString).integerValue
            let endTemp = (list[fin[i][j]][2] as NSString).integerValue
            print (startTemp)
            print (endTemp)
            if startTime <= endTemp{
                fits = false
            }
        }
        if fits{
            temp[i].append(x)
            return temp
        }
    }
    temp.append([x])
    return temp
}
func pickPos(positions : [[Int]], x : Int) -> Int{
    for i in 0..<positions.count{
        for j in 0..<positions[i].count{
            if x == positions[i][j]{
                return i
            }
        }
    }
    return 0
}

#Preview {
    CalendarView()
}


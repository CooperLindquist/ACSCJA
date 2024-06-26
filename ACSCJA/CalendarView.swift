////
////  CalendarView.swift
////  ACSCJA
////
////  Created by 64000270 on 4/1/24.
////
//
//import SwiftUI
//
//
//struct CalendarView: View {
//    @ObservedObject var model = CalendarViewModel()
//    @State var date = NSDate()
//    @State var dateFormatter = DateFormatter()
//    //@State var curDate = DateComponents()
//    //NSDate()//Date().formatted(.dateTime.day().month().year())
//    @State var dates = [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]]
//    @State var day = ""
//    //@State var disDay = 0
//    @State var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
//    @State var month = ""
//    @State var disMonth = 1
//    @State var year = ""
//    @State var disYear = 0
//    @State var descriptions = []
//    @State var names = [""]
//    @State var startTimes = []
//    @State var endTimes = []
//    @State var weekday = Calendar.current.component(.weekday, from: Date())
//    @State var dateSelected = 0
//    @State var time = 8
//    @State var temp = ""
//    @State var calIndex = 0
//    
//    @State var actSchedule = [["","",""]]
//    @State var times = []
//    @State var positional: [[Int]] = [[]]
//    @State var frameWidth = 0
//    
//    @State private var showingAddScoreSheet = false
//    @State private var showingSecondSheet = false
//    @State private var userInput: String = ""
//    @State private var passwordMatched = false
//    
//  
//    var body: some View {
//        VStack{
//            ZStack{
//                HStack{
//                    Spacer()
//                    Button {
//                        dates = changeDates(disDay: dates[0][2], disMonth: dates[0][1], dates : dates, shift : -7)
//                        disMonth = dates[calIndex][1]
//                        actSchedule = getEvents(model : model.array, selectedDate : "\(dates[calIndex][0])" + "\(String(format: "%02d", dates[calIndex][1]))" + "\(String(format: "%02d", dates[calIndex][2]))")
//                        positional = findPos(list : actSchedule)
//                    } label: {
//                        Text("<")
//                    }
//                    Spacer()
//                    Text("\(months[disMonth - 1])")
//                    Spacer()
//                    Button {
//                        dates = changeDates(disDay: dates[0][2], disMonth: dates[0][1], dates : dates, shift : 7)
//                        disMonth = dates[calIndex][1]
//                        actSchedule = getEvents(model : model.array, selectedDate : "\(dates[calIndex][0])" + "\(String(format: "%02d", dates[calIndex][1]))" + "\(String(format: "%02d", dates[calIndex][2]))")
//                        positional = findPos(list : actSchedule)
//                    } label: {
//                        Text(">")
//                    }
//                    Spacer()
//                }
//                .foregroundColor(.black)
//                .font(.custom("Popppins-Regular", size: 18))
//
//            }
//            HStack{
//                Button(action: {
//                    dateSelected = 0
//                    calIndex = 0
//                    disMonth = dates[0][1]
//                    actSchedule = getEvents(model : model.array, selectedDate : "\(dates[calIndex][0])" + "\(String(format: "%02d", dates[calIndex][1]))" + "\(String(format: "%02d", dates[calIndex][2]))")
//                    positional = findPos(list : actSchedule)
//                    print(model.array.count)
//                    
//                    
//                }, label: {
//                    VStack{
//                        Text("S")
//                            .font(.custom("Popppins-Regular", size: 15))
//                            .foregroundColor(.black)
//                            .padding(.top, 12)
//                            .frame(width: 45, height: 25)
//                        
//                        Text("\(dates[0][2])")
//                            .font(.custom("Poppins-Bold", size: 15))
//                            .foregroundColor(.red)
//                            .padding(.bottom, 12)
//                            .frame(width: 45, height: 25)
//                    }
//                    
//                    
//                })
//                .background(dateSelected == 0 ? Color("SelectBgr") : .white)
//                .cornerRadius(15)
//                
//                Button(action: {
//                    print("poop")
//                    dateSelected = 1
//                    calIndex = 1
//                    disMonth = dates[1][1]
//                    actSchedule = getEvents(model : model.array, selectedDate : "\(dates[calIndex][0])" + "\(String(format: "%02d", dates[calIndex][1]))" + "\(String(format: "%02d", dates[calIndex][2]))")
//                    positional = findPos(list : actSchedule)
//                }, label: {
//                    VStack{
//                        Text("M")
//                            .font(.custom("Popppins-Regular", size: 15))
//                            .foregroundColor(.black)
//                            .padding(.top, 12)
//                            .frame(width: 45, height: 25)
//                        
//                        Text("\(dates[1][2])")
//                            .font(.custom("Poppins-Bold", size: 15))
//                            .fontWeight(.black)
//                            .foregroundColor(.red)
//                            .padding(.bottom, 12)
//                            .frame(width: 45, height: 25)
//                    }
//                    
//                    
//                })
//                .background(dateSelected == 1 ? Color("SelectBgr") : .white)
//                .cornerRadius(15)
//                
//                Button(action: {
//                    dateSelected = 2
//                    calIndex = 2
//                    disMonth = dates[2][1]
//                    actSchedule = getEvents(model : model.array, selectedDate : "\(dates[calIndex][0])" + "\(String(format: "%02d", dates[calIndex][1]))" + "\(String(format: "%02d", dates[calIndex][2]))")
//                    positional = findPos(list : actSchedule)
//                }, label: {
//                    VStack{
//                        Text("T")
//                            .font(.custom("Popppins-Regular", size: 15))
//                            .foregroundColor(.black)
//                            .padding(.top, 12)
//                            .frame(width: 45, height: 25)
//                        
//                        Text("\(dates[2][2])")
//                            .font(.custom("Poppins-Bold", size: 15))
//                            .fontWeight(.black)
//                            .foregroundColor(.red)
//                            .padding(.bottom, 12)
//                            .frame(width: 45, height: 25)
//                    }
//                    
//                    .background(dateSelected == 2 ? Color("SelectBgr") : .white)
//                })
//                
//                .cornerRadius(15)
//                
//                Button(action: {
//                    dateSelected = 3
//                    calIndex = 3
//                    disMonth = dates[3][1]
//                    actSchedule = getEvents(model : model.array, selectedDate : "\(dates[calIndex][0])" + "\(String(format: "%02d", dates[calIndex][1]))" + "\(String(format: "%02d", dates[calIndex][2]))")
//                    positional = findPos(list : actSchedule)
//                }, label: {
//                    VStack{
//                        Text("W")
//                            .font(.custom("Popppins-Regular", size: 15))
//                            .foregroundColor(.black)
//                            .padding(.top, 12)
//                            .frame(width: 45, height: 25)
//                        
//                        Text("\(dates[3][2])")
//                            .font(.custom("Poppins-Bold", size: 15))
//                            .fontWeight(.black)
//                            .foregroundColor(.red)
//                            .padding(.bottom, 12)
//                            .frame(width: 45, height: 25)
//                    }
//                    
//                    .background(dateSelected == 3 ? Color("SelectBgr") : .white)
//                })
//                
//                .cornerRadius(15)
//                
//                Button(action: {
//                    dateSelected = 4
//                    calIndex = 4
//                    disMonth = dates[4][1]
//                    actSchedule = getEvents(model : model.array, selectedDate : "\(dates[calIndex][0])" + "\(String(format: "%02d", dates[calIndex][1]))" + "\(String(format: "%02d", dates[calIndex][2]))")
//                    positional = findPos(list : actSchedule)
//                }, label: {
//                    VStack{
//                        Text("T")
//                            .font(.custom("Popppins-Regular", size: 15))
//                            .foregroundColor(.black)
//                            .padding(.top, 12)
//                            .frame(width: 45, height: 25)
//                        
//                        Text("\(dates[4][2])")
//                            .font(.custom("Poppins-Bold", size: 15))
//                            .fontWeight(.black)
//                            .foregroundColor(.red)
//                            .padding(.bottom, 12)
//                            .frame(width: 45, height: 25)
//                    }
//                    
//                    .background(dateSelected == 4 ? Color("SelectBgr") : .white)
//                })
//                
//                .cornerRadius(15)
//                
//                Button(action: {
//                    dateSelected = 5
//                    calIndex = 5
//                    disMonth = dates[5][1]
//                    actSchedule = getEvents(model : model.array, selectedDate : "\(dates[calIndex][0])" + "\(String(format: "%02d", dates[calIndex][1]))" + "\(String(format: "%02d", dates[calIndex][2]))")
//                    positional = findPos(list : actSchedule)
//                }, label: {
//                    VStack{
//                        Text("F")
//                            .font(.custom("Popppins-Regular", size: 15))
//                            .foregroundColor(.black)
//                            .padding(.top, 12)
//                            .frame(width: 45, height: 25)
//                        
//                        Text("\(dates[5][2])")
//                            .font(.custom("Poppins-Bold", size: 15))
//                            .fontWeight(.black)
//                            .foregroundColor(.red)
//                            .padding(.bottom, 12)
//                            .frame(width: 45, height: 25)
//                    }
//                    
//                    .background(dateSelected == 5 ? Color("SelectBgr") : .white)
//                })
//                
//                .cornerRadius(15)
//                
//                Button(action: {
//                    dateSelected = 6
//                    calIndex = 6
//                    disMonth = dates[6][1]
//                    actSchedule = getEvents(model : model.array, selectedDate : "\(dates[calIndex][0])" + "\(String(format: "%02d", dates[calIndex][1]))" + "\(String(format: "%02d", dates[calIndex][2]))")
//                    positional = findPos(list : actSchedule)
//                }, label: {
//                    VStack{
//                        Text("S")
//                            .font(.custom("Popppins-Regular", size: 15))
//                            .foregroundColor(.black)
//                            .padding(.top, 12)
//                            .frame(width: 45, height: 25)
//                        
//                        Text("\(dates[6][2])")
//                            .font(.custom("Poppins-Bold", size: 15))
//                            .fontWeight(.black)
//                            .foregroundColor(.red)
//                            .padding(.bottom, 12)
//                            .frame(width: 45, height: 25)
//                    }
//                    
//                    .background(dateSelected == 6 ? Color("SelectBgr") : .white)
//                })
//                
//                .cornerRadius(15)
//            }
//            Divider()
//            ScrollView(){
//                HStack{
//                    Spacer()
//                    Spacer()
//                    VStack{
//                        Text("Time")
//                            .font(.custom("Poppins-Regular", size: 17))
//                        ForEach(0...23, id: \.self) { index in
//                            Text(String(index) + ":00")
//                                .font(.custom("Poppins-Regular", size: 17))
//                                .padding(.bottom, 7.0)
//                        }
//                    }
//                    
//                    Spacer()
//                    Spacer()
//                    Divider()
//                    ScrollView(.horizontal){
//                        ZStack{
//                            Text("Event")
//                                .font(.custom("Poppins-Regular", size: 17))
//                                .position(x: 25, y: 12)
//                            ForEach(0..<actSchedule.count, id: \.self) {index in
//                                Button {
//                                    //New screen for information
//                                } label: {
//                                    Text(actSchedule[index][0])
//                                        .font(.custom("Poppins-Regular", size: 16))
//                                        .foregroundColor(Color.black)
//                                        .frame(width: 140.0, height: 32 + 40 * CGFloat(diff(list : actSchedule, x : index)))
//                                    
//                                }
//                                .background(Color("SelectBgr"))
//                                .cornerRadius(10)
//                                .position(x: 75 + 150 * CGFloat(pickPos(positions : positional, x : index)), y: CGFloat(sumOf(list : actSchedule, x : index) * 20 + 33))
//                            }
//                        }
//                        .frame(width: CGFloat(frameWidth))
//                        //your fucntion sucks make so like lists and like if you can put it there put it there
//                    }
//                }
//            }
//            .refreshable{
//                model.getData()
//                actSchedule = getEvents(model : model.array, selectedDate : "\(dates[calIndex][0])" + "\(String(format: "%02d", dates[calIndex][1]))" + "\(String(format: "%02d", dates[calIndex][2]))")
//                positional = findPos(list : actSchedule)
//            }
//        }
//        .onAppear{
//            actSchedule.removeAll()
//            model.getData()
//            print(model.array.count)
//            print(names)
//            names.removeFirst()
//            //createScheduleArray(model: model.array)
//            day = setDay(date : date, dateFormatter : dateFormatter)
//            dateSelected = weekday - 1
//            calIndex = dateSelected
//            dates[0][2] = (day as NSString).integerValue - dateSelected
//            dates = initDays(dates : dates)
//            month = setMonth(date : date, dateFormatter : dateFormatter)
//            disMonth = (month as NSString).integerValue
//            year = setYear(date : date, dateFormatter : dateFormatter)
//            disYear = (year as NSString).integerValue
//            dates = initYears(disYear: disYear, calIndex : calIndex, dates : dates)
//            dates = initMonths(disMonth: disMonth, calIndex : calIndex, dates : dates)
//            dates = changeDates(disDay: dates[0][2], disMonth: disMonth, dates : dates, shift : 0)
//            actSchedule = getEvents(model : model.array, selectedDate : "\(dates[calIndex][0])" + "\(String(format: "%02d", dates[calIndex][1]))" + "\(String(format: "%02d", dates[calIndex][2]))")
//            positional = findPos(list : actSchedule)
//            frameWidth = 1000
//            //largestPos(positions : positional[0]) * 50
//            
//        }
//        .sheet(isPresented: $showingAddScoreSheet, onDismiss: {
//            // Handle user input here, for example, save to database
//            if userInput == "Joe" {
//                showingSecondSheet = true
//            }
//        }, content: {
//            VStack {
//                TextField("Enter password", text: $userInput)
//                    .padding()
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                Button("Done") {
//                    showingAddScoreSheet.toggle() // Dismiss the first sheet
//                }
//                .padding()
//            }
//            .padding()
//        })
//        .sheet(isPresented: $showingSecondSheet, content: {
//            AddCalendarView() // Show second sheet if password matches
//        })
//    }
// 
//func diff(list : [[String]], x : Int) -> Int{
//    let first = (list[x][1] as NSString).integerValue
//    let next = (list[x][2] as NSString).integerValue
//    return abs(first - next)
//}
//func sumOf(list : [[String]], x : Int) -> Int{
//    let first = (list[x][1] as NSString).integerValue
//    let next = (list[x][2] as NSString).integerValue
//    return first + next
//}
//   
//}
//func findPos(list : [[String]]) -> [[Int]] {
//    var fin: [[Int]] = [[]]
//    for x in 0..<list.count{
//        let startTime = (list[x][1] as NSString).integerValue
//        print(startTime)
//        fin = placed(list : list, fin : fin, startTime : startTime, x : x)
//        
//    }
//    print (fin)
//    return fin
//}
//func placed(list : [[String]], fin : [[Int]], startTime : Int, x : Int) -> [[Int]]{
//    var temp = fin
//    for i in 0..<fin.count {
//        var fits = true
//        for j in 0..<fin[i].count{
//            let endTemp = (list[fin[i][j]][2] as NSString).integerValue
//            if startTime <= endTemp{
//                fits = false
//            }
//        }
//        if fits{
//            temp[i].append(x)
//            return temp
//        }
//    }
//    temp.append([x])
//    return temp
//}
//func pickPos(positions : [[Int]], x : Int) -> Int{
//    for i in 0..<positions.count{
//        for j in 0..<positions[i].count{
//            if x == positions[i][j]{
//                return i
//            }
//        }
//    }
//    return 0
//}
//func setDay(date : NSDate, dateFormatter : DateFormatter) -> String{
//    dateFormatter.dateFormat = "dd"
//    return dateFormatter.string(from: date as Date)
//}
//func setMonth(date : NSDate, dateFormatter : DateFormatter) -> String{
//    dateFormatter.dateFormat = "MM"
//    return dateFormatter.string(from: date as Date)
//}
//func setYear(date : NSDate, dateFormatter : DateFormatter) -> String{
//    dateFormatter.dateFormat = "yyyy"
//    return dateFormatter.string(from: date as Date)
//}
//func createScheduleArray(model: [CalendarEvent]) -> [[[[String]]]]{
//    var fin = [[[]]]
//    for _ in 0...11 {
//        fin.append([])
//        print(fin.count)
//    }
//    for item in model{
//        print(item.Name)
//        print("yaas")
//    }
//    print(model.count)
//    return [[[[""]]]]
//}
//func getEvents(model : [CalendarEvent], selectedDate : String) -> [[String]]{
//    var fin = [[""]]
//    print(selectedDate)
//    for item in model{
//        if(selectedDate == item.Date){
//            fin.append([item.Name, item.StartTime, item.EndTime])
//        }
//    }
//    fin.removeFirst()
//    
//    return sortArray(arr: fin)
//}
//func sortArray(arr : [[String]]) -> [[String]]{
//    var fin = arr
//    fin.sort {($0[1] as NSString).integerValue < ($1[1] as NSString).integerValue}
//    return fin
//}
//func initDays(dates : [[Int]]) -> [[Int]]{
//    var fin = dates
//    for i in 1..<fin.count{
//        fin[i][2] = fin[0][2] + i
//    }
//    print(fin)
//    return fin
//}
//func initMonths(disMonth : Int, calIndex : Int, dates : [[Int]]) -> [[Int]]{
//    var fin = dates
//    for i in 0..<fin.count{
//        fin[i][1] = disMonth
//    }
//    return fin
//}
//func initYears(disYear : Int, calIndex: Int, dates : [[Int]]) -> [[Int]]{
//    var fin = dates
//    for i in 0..<fin.count{
//        fin[i][0] = disYear
//    }
//    return fin
//}
//func changeDates(disDay : Int, disMonth: Int, dates : [[Int]], shift : Int) -> [[Int]]{
//    var fin = dates
//    for i in 0..<fin.count{
//        fin[i][2] += shift
//    }
//    
//    fin = fixMonth(dates : fin)
//    
//    
//    return fin
//}
//func largestPos(positions : [Int]) -> Int{
//    var fin = 0
//    for i in positions{
//        if i > fin{
//            fin = i
//        }
//    }
//    return fin
//}
//func fixMonth(dates: [[Int]]) -> [[Int]]{
//    var fin = dates
//    for i in 0..<fin.count{
//        if fin[i][2] <= 0{
//           fin[i][1] -= 1
//            if fin[i][1] <= 0{
//                fin[i][1] = 12
//                fin[i][0] -= 1
//            }
//            if fin[i][1] == 1{
//                fin[i][2] += 31
//            }
//            else if fin[i][1] == 2{
//                fin[i][2] += 28
//            }
//            else if fin[i][1] == 3{
//                fin[i][2] += 31
//            }
//            else if fin[i][1] == 4{
//                fin[i][2] += 30
//            }
//            else if fin[i][1] == 5{
//                fin[i][2] += 31
//            }
//            else if fin[i][1] == 6{
//                fin[i][2] += 30
//            }
//            else if fin[i][1] == 7{
//                fin[i][2] += 31
//            }
//            else if fin[i][1] == 8{
//                fin[i][2] += 31
//            }
//            else if fin[i][1] == 9{
//                fin[i][2] += 30
//            }
//            else if fin[i][1] == 10{
//                fin[i][2] += 31
//            }
//            else if fin[i][1] == 11{
//                fin[i][2] += 30
//            }
//            else if fin[i][1] == 12{
//                fin[i][2] += 31
//            }
//        }
//        if fin[i][1] == 1 && fin[i][2] > 31{
//            fin[i][1] += 1
//            fin[i][2] -= 31
//        }
//        else if fin[i][1] == 2 && fin[i][2] > 28{
//            fin[i][1] += 1
//            fin[i][2] -= 28
//        }
//        else if fin[i][1] == 3 && fin[i][2] > 31{
//            fin[i][1] += 1
//            fin[i][2] -= 31
//        }
//        else if fin[i][1] == 4 && fin[i][2] > 30{
//            fin[i][1] += 1
//            fin[i][2] -= 30
//        }
//        else if fin[i][1] == 5 && fin[i][2] > 31{
//            fin[i][1] += 1
//            fin[i][2] -= 31
//        }
//        else if fin[i][1] == 6 && fin[i][2] > 30{
//            fin[i][1] += 1
//            fin[i][2] -= 30
//        }
//        else if fin[i][1] == 7 && fin[i][2] > 31{
//            fin[i][1] += 1
//            fin[i][2] -= 31
//        }
//        else if fin[i][1] == 8 && fin[i][2] > 31{
//            fin[i][1] += 1
//            fin[i][2] -= 31
//        }
//        else if fin[i][1] == 9 && fin[i][2] > 30{
//            fin[i][1] += 1
//            fin[i][2] -= 30
//        }
//        else if fin[i][1] == 10 && fin[i][2] > 31{
//            fin[i][1] += 1
//            fin[i][2] -= 31
//        }
//        else if fin[i][1] == 11 && fin[i][2] > 30{
//            fin[i][1] += 1
//            fin[i][2] -= 30
//        }
//        else if fin[i][1] == 12 && fin[i][2] > 31{
//            fin[i][1] += 1
//            fin[i][2] -= 31
//        }
//        if fin[i][1] >= 13{
//            fin[i][1] = 1
//            fin[i][0] += 1
//        }
//    }
//    print(fin)
//    return fin
//}
//
//#Preview {
//    CalendarView()
//}
//

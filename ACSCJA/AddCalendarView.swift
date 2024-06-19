//import SwiftUI
//import Firebase
//
//struct AddCalendarView: View {
//    @State private var nameString: String = ""
//    @State private var startTimeString: String = ""
//    @State private var endTimeString: String = ""
//    @State private var dateString: String = ""
//    @State private var locationString: String = ""
//    @State private var descriptionString: String = ""
//    
//    var body: some View {
//        ZStack {
//            RadialGradient(gradient: Gradient(colors: [Color("goodRed"), Color("SelectBgr")]), center: UnitPoint(x: 0, y: 0.1), startRadius: 0, endRadius: 1200)
//                .edgesIgnoringSafeArea(.all)
//            VStack {
//                VStack(alignment: .leading) {
//                    Text("Add Event")
//                        .font(.custom("Poppins-Medium", size: 47))
//                        .foregroundColor(.white)
//                        .padding(.bottom)
//                    Text("Name of Event")
//                        .font(.custom("Poppins-Medium", size: 13))
//                        .foregroundColor(.white)
//                    TextField("", text: $nameString)
//                        .padding(10.0)
//                        .background(Color.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
//                        .padding(.bottom)
//                    HStack {
//                        Text("Start Time (Millitary)")
//                            .font(.custom("Poppins-Medium", size: 13))
//                            .foregroundColor(.white)
//                            .padding(.trailing, 28)
//                        Text("End Time (Millitary)")
//                            .font(.custom("Poppins-Medium", size: 13))
//                            .foregroundColor(.white)
//                    }
//                    HStack {
//                        TextField("", text: $startTimeString)
//                            .padding(10.0)
//                            .background(Color.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
//                            .padding(.bottom)
//                        TextField("", text: $endTimeString)
//                            .padding(10.0)
//                            .background(Color.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
//                            .padding(.bottom)
//                    }
//                    Text("Event Date (mm/dd/yyyy)")
//                        .font(.custom("Poppins-Medium", size: 13))
//                        .foregroundColor(.white)
//                    TextField("", text: $dateString)
//                        .padding(10.0)
//                        .background(Color.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
//                        .padding(.bottom)
//                    Text("Event Location")
//                        .font(.custom("Poppins-Medium", size: 13))
//                        .foregroundColor(.white)
//                    TextField("", text: $locationString)
//                        .padding(10.0)
//                        .background(Color.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
//                        .padding(.bottom)
//                    Text("Event Description")
//                        .font(.custom("Poppins-Medium", size: 13))
//                        .foregroundColor(.white)
//                    TextEditor(text: $descriptionString)
//                        .padding(10.0)
//                        .padding(.bottom, 40.0)
//                        .background(Color.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
//                        .padding(.bottom)
//                }
//                .padding(30.0)
//                Button {
//                    startTimeString = fixTime(time : startTimeString)
//                    endTimeString = fixTime(time : endTimeString)
//                    dateString = fixDate(date: dateString)
//                    saveScore()
//                } label: {
//                    Text("Add Event")
//                        .font(.custom("Poppins-Medium", size: 20))
//                        .frame(width: 325.0, height: 50.0)
//                        .foregroundColor(.white)
//                        .background(Color("goodRed"))
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                }
//            }
//        }
//    }
//    func fixTime(time : String) -> String{
//        var fin = ""
//        for x in 0..<time.count{
//            if (String(substring(time, from: x, to : x) ?? "00")) == ":"{
//                fin = String(substring(time, from: 0, to : x - 1) ?? "00")
//            }
//        }
//        return fin
//    }
//    func fixDate(date : String) -> String{
//        
//        let year = String(substring(date, from: 6, to : 9) ?? "0000")
//        let month = String(substring(date, from: 0, to : 1) ?? "00")
//        let day = String(substring(date, from: 3, to : 4) ?? "00")
//        let fin = year + month + day
//        return fin
//    }
//    func substring(_ str: String, from start: Int, to end: Int) -> String? {
//        guard start >= 0, end < str.count, start <= end else { return nil }
//        let startIndex = str.index(str.startIndex, offsetBy: start)
//        let endIndex = str.index(str.startIndex, offsetBy: end + 1)
//        return String(str[startIndex..<endIndex])
//    }
//    
//    func saveScore() {
//        let db = Firestore.firestore()
//
//        // Define the data dictionary to be saved
//        let data: [String: Any] = [
//            "Name": nameString,
//            "Date": dateString,
//            "Description": descriptionString,
//            "StartTime": startTimeString,
//            "EndTime": endTimeString,
//            "Location": locationString
//        ]
//
//        // Add the document to the "Score" collection
//        db.collection("CalendarEvent").addDocument(data: data) { error in
//            if let error = error {
//                print("Error adding document: \(error.localizedDescription)")
//            } else {
//                print("Document added successfully")
//
//                // Optionally, clear the text fields after saving
//                self.nameString = ""
//                self.startTimeString = ""
//                self.endTimeString = ""
//                self.dateString = ""
//                self.descriptionString = ""
//                self.locationString = ""
//            }
//        }
//    }
//}
//
//#Preview {
//    AddCalendarView()
//}

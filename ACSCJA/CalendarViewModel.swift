//import SwiftSoup
//import Combine
//import Foundation
//
//class CalendarViewModel: ObservableObject {
//    @Published var events: [CalendarEvent] = []
//
//    func fetchEvents() {
//        guard let url = URL(string: "https://www.edenpr.org/experience/calendar") else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data, error == nil {
//                if let html = String(data: data, encoding: .utf8) {
//                    self.parseHTML(html)
//                }
//            } else {
//                print("Failed to fetch data: \(String(describing: error))")
//            }
//        }.resume()
//    }
//
//    private func parseHTML(_ html: String) {
//        do {
//            let document = try SwiftSoup.parse(html)
//            let eventElements = try document.select(".slick-slide") // Updated selector for your events
//
//            var fetchedEvents: [CalendarEvent] = []
//
//            for element in eventElements {
//                let title = try element.select(".fsTitle a").text()
//                let date = try element.select("time.fsDate").text() // Update selector for date
//                let time = try element.select(".fsTimeRange").text() // Update selector for time
//                let location = try element.select(".fsLocation").text() // Update selector for location
//                let link = try element.select(".fsTitle a").attr("href") // Update selector for link
//
//                let event = CalendarEvent(title: title, date: date, time: time, location: location, link: link)
//                fetchedEvents.append(event)
//                
//                // Debugging statements
//                print("Fetched event: \(event)")
//            }
//
//            DispatchQueue.main.async {
//                self.events = fetchedEvents
//            }
//        } catch {
//            print("Failed to parse HTML: \(error)")
//        }
//    }
//}

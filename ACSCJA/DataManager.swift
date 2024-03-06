//
//  DataManager.swift
//  ACSCJA
//
//  Created by 90310805 on 3/25/24.
//

import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var CalendarEvents: [CalendarEvent] = []
    
    init() {
        fetchEvents()
    }
    
    func fetchEvents() {
        CalendarEvents.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Events")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let time = data["time"] as? String ?? ""
                    let what = data["what"] as? String ?? ""
                    
                    let calendarevent = CalendarEvent(id: id, time: time, what: what)
                    self.CalendarEvents.append(calendarevent)
                }
            }
            
        }
    }
}

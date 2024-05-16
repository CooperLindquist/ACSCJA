//
//  CalendarViewModel.swift
//  ACSCJA
//
//  Created by 64000270 on 5/6/24.
//

import Foundation
import Firebase
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var array = [CalendarEvent]()
    @Published var names = [String]()
    func getData() {
        let db = Firestore.firestore()
        db.collection("CalendarEvent").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                return
            }
            
            DispatchQueue.main.async {
                self.array = snapshot.documents.compactMap { document in
                    let data = document.data()
                    guard
                        let date = data["Date"] as? String,
                        let description = data["Description"] as? String,
                        let endTime = data["EndTime"] as? String,
                        let name = data["Name"] as? String,
                        let startTime = data["StartTime"] as? String
                    else {
                        print("Invalid data for document \(document.documentID)")
                        return nil
                    }
                    
                    return CalendarEvent(
                        id: document.documentID,
                        Date: date,
                        Description: description,
                        EndTime: endTime,
                        Name: name,
                        StartTime: startTime
                    )
                }
            }
        }
    }
}


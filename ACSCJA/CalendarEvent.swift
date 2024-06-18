//
//  CalendarEvent.swift
//  ACSCJA
//
//  Created by 90310805 on 3/25/24.
//

import Foundation

struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let time: String
    let location: String
    let link: String
}

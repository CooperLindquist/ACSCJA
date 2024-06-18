//
//  Score.swift
//  ACSCJA
//
//  Created by 90310805 on 4/22/24.
//

import Foundation

struct Score: Identifiable, Hashable, Codable {
    var id : String
    var Date : String
    var AwayTeam : String
    var EPScore : Int
    var OtherScore : Int
    var Sport : String
    var Gender : String
    var Level : String
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
           // Hash other properties if needed
       }
}

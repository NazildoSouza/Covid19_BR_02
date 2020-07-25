//
//  Model.swift
//  Covid19_BR_02
//
//  Created by Nazildo Souza on 25/07/20.
//

import SwiftUI

struct MainData: Codable {
    let cases: Int
    let deaths: Int
    let recovered: Int
    let active: Int
    let critical: Int
}

struct MyCountry: Codable {
    let country: String
    let province: [String]
    let timeline: Timeline
}

struct Timeline: Codable {
    let cases, deaths, recovered: [String: Int]
}

struct Daily: Identifiable, Comparable {
    static func < (lhs: Daily, rhs: Daily) -> Bool {
        lhs.cases < rhs.cases
    }
    
    var id: Int
    var day: String
    var cases: Int
}

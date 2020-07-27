//
//  Model.swift
//  Covid19_BR_02
//
//  Created by Nazildo Souza on 25/07/20.
//

import SwiftUI

//struct MainData: Codable {
//    let cases: Int
//    let deaths: Int
//    let recovered: Int
//    let active: Int
//    let critical: Int
//}

// MARK: - MainData
struct MainData: Codable {
    let message: String?
    let updated: Int?
    let country: String?
    let countryInfo: CountryInfo?
    let cases, todayCases, deaths, todayDeaths: Int?
    let recovered, todayRecovered, active, critical: Int?
 //   let casesPerOneMillion, deathsPerOneMillion, tests, testsPerOneMillion: Int
    let population: Int?
    let continent: String?
 //   let oneCasePerPeople, oneDeathPerPeople, oneTestPerPeople: Int
 //   let activePerOneMillion, recoveredPerOneMillion, criticalPerOneMillion: Double
}

// MARK: - CountryInfo
struct CountryInfo: Codable {
    let id: Int
    let iso2, iso3: String
    let flag: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case iso2, iso3, flag
    }
}


struct MyCountry: Codable {
    let message: String?
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

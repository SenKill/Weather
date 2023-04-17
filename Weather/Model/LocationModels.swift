//
//  LocationModels.swift
//  Weather
//
//  Created by Serik Musaev on 17.04.2023.
//

import Foundation

struct CountryModel: Codable {
    let response: CountryResponse
}

struct CountryResponse: Codable {
    let count: Int
    let items: [Country]
}

struct Country: Codable, Identifiable {
    let id: Int
    let title: String
}

struct CityModel: Codable {
    let response: CityResponce
}

struct CityResponce: Codable {
    let count: Int
    let items: [City]
}

struct City: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let area: String?
    var region: String?
    let important: Int?
}

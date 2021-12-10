//
//  CitySelectorViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 12/10/21.
//

import Foundation

class CitySelectorViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var searchText = ""
    
    private let locationData = LocationData()
    
    func getCitiesData(lang: String, id: Int, query: String?, count: Int) {
        var newQuery = ""
        if let query = query {
            newQuery = "&q=" + query
        }
        locationData.getCities(language: lang, countryId: String(id), query: newQuery, count: String(count)) { (cities) in
            self.cities = cities
        }
    }
}

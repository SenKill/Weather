//
//  CitySelectorViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 12/10/21.
//

import Foundation
import Combine

class CitySelectorViewModel: ObservableObject {
    @Published var allCities: [City] = []
    @Published var cities: [City] = []
    private var sortedCities: [City] = []
    @Published var searchText = ""
    @Published var country: Country?
    
    private let locationData = LocationData()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func getCitiesData(lang: String, id: Int, query: String?, count: Int) {
        var newQuery = ""
        if let query = query {
            newQuery = "&q=" + query
        }
        locationData.getCities(language: lang, countryId: String(id), query: newQuery, count: String(count)) { (cities) in
            self.allCities = cities
        }
    }
    
    func addSubscribers() {
        // Updates cities
        $searchText
            .combineLatest($allCities)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCities)
            .sink { [weak self] (returnedCountries) in
                if let sortedCities = self?.sortedCities {
                    self?.cities = sortedCities
                }
            }
            .store(in: &cancellables)
    }
    
    private func filterCities(text: String, cities: [City]) {
        guard !text.isEmpty else {
            self.sortedCities = cities
            return
        }
        
        locationData.getCities(language: "en", countryId: String(country!.id), query: text, count: "50") { (cities) in
            self.sortedCities = cities
        }
    }
}

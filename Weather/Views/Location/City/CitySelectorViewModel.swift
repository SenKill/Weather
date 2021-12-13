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
    private var count = 0
    
    @Published var citySearchText = ""
    @Published var country: Country?
    
    private let locationData = LocationData()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func getCitiesData(lang: String, id: Int, query: String?, count: Int) {
        locationData.getCities(language: lang, countryId: String(id), query: "", count: String(count)) { (cities) in
            self.allCities = cities
        }
    }
    
    func addSubscribers() {
        // Updates cities
        $citySearchText
            .combineLatest($allCities)
            .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
            .map(filterCities)
            .sink {
                self.count+=1
                print("Loading cities", self.count)
                self.cities = self.sortedCities
            }
            .store(in: &cancellables)
    }
    
    private func filterCities(text: String, cities: [City]) {
        guard !text.isEmpty else {
            self.sortedCities = cities
            return
        }
        
        let query = "&q=" + text
        locationData.getCities(language: "en", countryId: String(country!.id), query: query, count: "50") { (cities) in
            self.sortedCities = cities
        }
    }
}

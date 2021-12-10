//
//  CountrySelectorViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 12/7/21.
//

import Foundation
import Combine

class CountrySelectorViewModel: ObservableObject {
    
    @Published var countries: [Country] = []
    @Published var allCountries: [Country] = []
    
    @Published var searchText: String = ""
    
    private let locationData = LocationData()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        getCountriesData(lang: "en")
    }
    
    func getCountriesData(lang: String) {
        locationData.getCountries(language: lang) { countries in
            self.countries = countries
            self.allCountries = countries
        }
    }
    
    func addSubscribers() {
        // Updates countries
        $searchText
            .combineLatest($allCountries)
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .map(filterCountries)
            .sink { [weak self] (returnedCountries) in
                self?.countries = returnedCountries
            }
            .store(in: &cancellables)
    }
    
    private func filterCountries(text: String, countries: [Country]) -> [Country] {
        guard !text.isEmpty else {
            return countries
        }
            
        let lowercasedText = text.lowercased()
            
        return countries.filter { (country) -> Bool in
            return country.title.lowercased().contains(lowercasedText)
        }
    }
}

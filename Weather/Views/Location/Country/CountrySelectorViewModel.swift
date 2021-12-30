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
    
    @Published var countrySearchText: String = ""
    
    private let locationData = LocationData()
    
    @Published var showLoadingView: Bool = false
    @Published var selectedCountry: Country?
    
    private var countryCancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        getCountriesData(lang: "en")
    }
    
    func getCountriesData(lang: String) {
        locationData.getCountries(language: lang) { countries in
            self.allCountries = countries
        }
    }
    
    private func addSubscribers() {
        // Updates countries
        $countrySearchText
            .combineLatest($allCountries)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCountries)
            .sink { [weak self] (returnedCountries) in
                self?.countries = returnedCountries
            }
            .store(in: &countryCancellables)
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

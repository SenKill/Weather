//
//  CountrySelectorViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 12/7/21.
//

import Foundation
import Combine

class CountrySelectorViewModel: ObservableObject {
    
    @Published var groupedCountries: [String: [Country]] = [:]
    @Published var allCountries: [Country] = []
    
    @Published var countrySearchText: String = ""
    
    private let locationData = LocationData()
    
    @Published var showLoadingView: Bool = false
    @Published var selectedCountry: Country?
    
    private var countryCancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        getCountriesData()
    }
    
    func groupContries(_ countriesArray: [Country]) {
        groupedCountries = Dictionary(
            grouping: countriesArray,
            by: {$0.title.first?.uppercased() ?? ""}
        ).mapValues{$0}
    }
    
    func getCountriesData() {
        var language: String {
            return Locale.current.languageCode ?? "en"
        }
        
        locationData.getCountries(language: language) { countries in
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
                self?.groupContries(returnedCountries)
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

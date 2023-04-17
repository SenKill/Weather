//
//  CountrySelectorViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 12/7/21.
//

import Foundation
import Combine

final class CountrySelectorViewModel: ObservableObject {
    @Published var groupedCountries: [String: [Country]] = [:]
    @Published var allCountries: [Country] = []
    @Published var countrySearchText: String = ""
    @Published var showLoadingView: Bool = false
    @Published var selectedCountry: Country?
    @Published var isAlertPresented: Bool = false
    var alertMessage: String = ""
    
    private let networkService = NetworkService()
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
        networkService.makeRequest(.vkCountries(token: Tokens.vk, lang: Locale.current), resultType: CountryModel.self) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.allCountries = data.response.items
            case .failure(let error):
                self.alertMessage = error.description
                self.isAlertPresented = true
            }
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

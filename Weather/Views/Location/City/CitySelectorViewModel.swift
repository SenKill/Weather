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
    
    @Published var citySearchText = ""
    @Published var country: Country?
    
    @Published var showCityView = false
    @Published var navigateToMain = false
    @Published var showAlert = false
    @Published var selectedCity: City? = nil
    @Published var dismissLoadingView = false
    
    private var cityCancellables = Set<AnyCancellable>()
    private var sortedCities: [City] = []
    
    init() {
        addSubscribers()
    }
    
    func getCitiesStart(id: Int, count: Int) {
        self.getCities(countryId: id, query: "", count: count) { [weak self] (cities) in
            self?.allCities = cities
        }
    }
    
    func selectCity(city: City) {
        self.selectedCity = city
        self.showAlert.toggle()
    }
    
    func changeCity() {
        self.selectedCity?.region = self.country?.title
        self.navigateToMain = true
        self.showCityView = false
    }
    
    private func addSubscribers() {
        // Updates cities
        $citySearchText
            .combineLatest($allCities)
            .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
            .map(filterCities)
            .sink{ }
            .store(in: &cityCancellables)
    }
    
    private func filterCities(text: String, cities: [City]) {
        guard !text.isEmpty else {
            self.cities = cities
            return
        }
        
        self.getCities(countryId: country!.id, query: "&q=" + text, count: 50) { [weak self] (cities) in
            self?.cities = cities
        }
    }
    
    private func getCities(countryId: Int, query: String, count: Int, completion: @escaping ([City]) -> ()) {
        guard let url = Endpoint.vkCities(token: Tokens.vk, countryId: countryId, query: query, count: count, lang: Locale.current).getUrlRequest() else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CityModel.self, decoder: JSONDecoder())
            .sink { _ in
                
            } receiveValue: { [weak self] (returnedCities) in
                self?.cities = returnedCities.response.items
                completion(returnedCities.response.items)
            }
            .store(in: &cityCancellables)
    }
}

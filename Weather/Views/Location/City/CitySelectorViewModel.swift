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
    
    @Published var citySearchText = ""
    @Published var country: Country?
    
    @Published var showCityView = false
    @Published var navigateToMain = false
    @Published var showAlert = false
    @Published var selectedCity: City? = nil
    @Published var dismissLoadingView = false
    
    var cityCancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func getCitiesStart(id: Int, query: String?, count: Int) {
        self.getCities(countryId: String(id), query: "", count: String(count)) { [weak self] (cities) in
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
        
        var query: String {
            return "&q=" + text
        }
        
        self.getCities(countryId: String(country!.id), query: query, count: "50") { [weak self] (cities) in
            self?.cities = cities
        }
    }
    
    private func getCities(countryId: String, query: String, count: String, completion: @escaping ([City]) -> ()) {
        var language: String {
            return Locale.current.languageCode ?? "en"
        }
        
        guard let url = URL(string: "https://api.vk.com/method/database.getCities?access_token=\(Tokens.vkAPI.rawValue)&country_id=\(countryId)\(query)&need_all=0&count=\(count)&lang=\(language)&v=5.131".encodeUrl) else {
                print("Wrong url")
                return }
        
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

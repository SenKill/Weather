//
//  LocationData.swift
//  Weather
//
//  Created by Serik Musaev on 12/5/21.
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
    let region: String?
    let important: Int?
}



final class LocationData {
    let accessToken = Tokens.vkAPI.rawValue
    func getCountries(language: String, completion: @escaping ([Country]) -> ()) {
        guard let url = URL(string: "https://api.vk.com/method/database.getCountries?access_token=\(accessToken)&need_all=1&count=1000&lang=\(language)&v=5.131") else {
            print("Wrong url")
            return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error with getting countries: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response(LocationData), status code: \(response!)")
                return
            }
            
            if let someData = data {
                do {
                    let locationData = try JSONDecoder().decode(CountryModel.self, from: someData)
                    DispatchQueue.main.async {
                        completion(locationData.response.items)
                    }
                } catch {
                    print(error)
                }
            }
        }
        .resume()
    }
    
    func getCities(language: String, countryId: String, query: String, count: String, completion: @escaping ([City]) -> ()) {
            guard let url = URL(string: "https://api.vk.com/method/database.getCities?access_token=\(accessToken)&country_id=\(countryId)\(query)&need_all=0&count=\(count)&lang=\(language)&v=5.131") else {
                print("Wrong url")
                return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error with getting countries: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response(LocationData), status code: \(response!)")
                return
            }
            
            if let someData = data {
                do {
                    let locationData = try JSONDecoder().decode(CityModel.self, from: someData)
                    DispatchQueue.main.async {
                        completion(locationData.response.items)
                    }
                } catch {
                    print(error)
                }
            }
        }
        .resume()
        /*
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
            .decode(type: [City].self, decoder: JSONDecoder())
            .sink { (completion) in
                print("COMPLETION: \(completion)")
            } receiveValue: { [weak self] (returnedCities) in
                self?.cities = returnedCities
            }
            .store(in: &cancellables)
        */
    }
}

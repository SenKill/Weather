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
    var region: String?
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
}

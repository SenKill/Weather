//
//  LocationData.swift
//  Weather
//
//  Created by Serik Musaev on 12/5/21.
//

import Foundation

struct LocationItems: Codable, Identifiable {
    let id: Int
    let title: String
    let area: String?
    let region: String?
}

struct Response: Codable {
    var count: Int
    var items: [LocationItems]
}

struct Location: Codable {
    let response: Response
}

final class LocationData {
    let accessToken = Tokens.vkAPI.rawValue
    func getCountries(language: String, completion: @escaping ([LocationItems]) -> ()) {
        guard let url = URL(string: "https://api.vk.com/method/database.getCountries?access_token=\(accessToken)&need_all=1&count=1000&lang=\(language)&v=5.131") else {
            print("Wrong url")
            return }
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if let error = error {
                print("Error with getting countries: \(error)")
                return
            }
            
            guard let httpResponse = responce as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, status code: \(responce!)")
                return
            }
            
            if let someData = data {
                let locationData = try! JSONDecoder().decode(Location.self, from: someData)
                
                DispatchQueue.main.async {
                    completion(locationData.response.items)
                }
            }
        }
        .resume()
    }
    
    func getCities(language: String, countryId: String, query: String, count: String, completion: @escaping (Location) -> ()) {
        guard let url = URL(string: "https://api.vk.com/method/database.getCities?access_token=\(accessToken)&country_id=\(countryId)&q=\(query)&need_all=1&count=\(count)&lang=\(language)&v=5.131") else {
            print("Wrong url")
            return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let locationData = try! JSONDecoder().decode(Location.self, from: data!)
            
            DispatchQueue.main.async {
                completion(locationData)
            }
        }
        .resume()
    }
}

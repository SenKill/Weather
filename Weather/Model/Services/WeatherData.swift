//
//  WeatherData.swift
//  Weather
//
//  Created by Serik Musaev on 10/13/21.
//

import Foundation
import CoreData


final class WeatherData {
    static func getData(latitude: String, longtitude: String, units: String, language: String, completion: @escaping (Result<WeatherModel, NetworkError>) -> ()) {
        let decoder = JSONDecoder()
        let appId = Tokens.openWeatherMap.rawValue
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longtitude)&exclude=minutely,alerts&units=\(units)&lang=\(language)&appid=\(appId)") else {
            completion(.failure(.wrongUrl))
            return
        }
        print(url.absoluteString)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.someError(message: error.localizedDescription)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")
            if !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.reponseError(statusCode: httpResponse.statusCode)))
                return
            }
            
            if let data = data {
                let weatherData = try! decoder.decode(WeatherModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(weatherData))
                }
            }
        }
        .resume()
    }
}

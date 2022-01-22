//
//  WeatherData.swift
//  Weather
//
//  Created by Serik Musaev on 10/13/21.
//

import Foundation
import CoreData


final class WeatherData {
    static func getData(latitude: String, longtitude: String, units: String, language: String, context: NSManagedObjectContext, completion: @escaping (Result<WeatherModel, Error>) -> ()) {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longtitude)&exclude=minutely,alerts&units=\(units)&lang=\(language)&appid=a0c0a6cb62d01e7faf2d0aa659b1b981") else {
            print("Wrong URL")
            return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let httpResopnce = response as? HTTPURLResponse,(200...299).contains(httpResopnce.statusCode) else {
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

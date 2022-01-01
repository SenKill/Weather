//
//  WeatherData.swift
//  Weather
//
//  Created by Serik Musaev on 10/13/21.
//

import Foundation

struct WeatherDescription: Codable {
    var id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temperature: Codable {
    let day: Float
    let night: Float
    let eve: Float
    let morn: Float
    let min: Float
    let max: Float
}

struct TemperatureFeels: Codable {
    let day: Float
    let night: Float
    let eve: Float
    let morn: Float
}

struct CurrentWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Float
    let feels_like: Float
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let uvi: Float
    let clouds: Int
    let visibility: Int
    let wind_speed: Float
    let wind_deg: Int
    let weather: [WeatherDescription]
}

struct DailyWeather: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moonset: Int
    let moon_phase: Float
    let temp: Temperature
    let feels_like: TemperatureFeels
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let wind_speed: Float
    let wind_deg: Int
    let wind_gust: Float
    let weather: [WeatherDescription]
    let clouds: Int
    let pop: Float
    let rain: Float?
    let uvi: Float
}

struct HourlyWeather: Codable {
    let dt: Int
    let temp: Float
    let feels_like: Float
    let pressure: Int
    let humidity: Int
    let dew_point: Float
    let uvi: Float
    let clouds: Int
    let visibility: Int
    let wind_speed: Float
    let wind_deg: Int
    let wind_gust: Float
    let weather: [WeatherDescription]
    let pop: Float
}

struct WeatherModel: Codable {
    var lat: Float
    var lon: Float
    var timezone: String
    var timezone_offset: Int
    
    var current: CurrentWeather
    var hourly: [HourlyWeather]
    var daily: [DailyWeather]
}

final class WeatherData {
    func getData(latitude: String, longtitude: String, units: String, completion: @escaping (WeatherModel) -> ()) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longtitude)&exclude=minutely,alerts&units=\(units)&appid=a0c0a6cb62d01e7faf2d0aa659b1b981") else {
            print("Wrong URL")
            return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error with getting weather data: \(error.localizedDescription)")
            }
            
            guard let httpResopnce = response as? HTTPURLResponse,(200...299).contains(httpResopnce.statusCode) else {
                print("Error with response(WeatherData), status code: \(response!)")
                return
            }
            
            if let data = data {
                let weatherData = try! JSONDecoder().decode(WeatherModel.self, from: data)
                DispatchQueue.main.async {
                    completion(weatherData)
                }
            }
        }
        .resume()
    }
    
    func cityToCoordinates(city: String) {
        
    }
}

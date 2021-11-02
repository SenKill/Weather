//
//  WeatherMainViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 10/10/21.
//

import Foundation
import SwiftUI

final class WeatherMainViewModel: ObservableObject {
    @Published var date: [String] = []
    @Published var degrees: [Temperature] = []
    @Published var weatherType: [WeatherDescription] = []
    @Published var windSpeed: [Float] = []
    
    @Published var cTemperature: String?
    @Published var cWeather: String?
    @Published var cWindSpeed: Float?
    
    func bindWeatherData() {
        Api().getData() { (data) in
            self.cTemperature = String(format: "%.0f", data.current.temp)
            self.cTemperature?.append("ºC")
            self.cWeather = data.current.weather[0].main
            self.cWindSpeed = data.current.wind_speed
            
            
            let timeZone = TimeZone(identifier: data.timezone)
            for i in 0..<data.daily.count {
                self.date.append(Double(data.daily[i].dt).getDateFromUTC(timeZone: timeZone!))
                self.degrees.append(data.daily[i].temp)
                self.weatherType.append(contentsOf: data.daily[i].weather)
                self.windSpeed.append(data.daily[i].wind_speed)
            }
        }
    }
    
    func setGradient(weather: String) -> LinearGradient? {
        var colors: [Color]
        switch weather {
        case "Clear":
            colors = [.white, .orange]
            break;
        case "Clouds":
            colors = [.white, .blue]
            break;
        case "Rain":
            colors = [.gray, .blue]
            break;
        default:
            print("ERROR: Wrong weather was inputed!")
            return nil
        }
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .topTrailing, endPoint: .bottom)
    }
}

struct DailyForecast<Content: View>: View {
    let date: [String]
    let degrees: [Temperature]
    let weatherType: [WeatherDescription]
    let windSpeed: [Float]
    let columns: Int
    let content: ([String], [Temperature], [WeatherDescription], [Float], Int) -> Content
    
    var body: some View {
        HStack {
            ForEach(0 ..< self.columns) { column in
                self.content(date, degrees, weatherType, windSpeed, column)
                    .font(.system(size: 20, weight: .semibold, design: .default))
            }
        }
    }
    
    init(date: [String], degrees: [Temperature], weatherType: [WeatherDescription], windSpeed: [Float], columns: Int, @ViewBuilder content: @escaping ([String], [Temperature], [WeatherDescription], [Float], Int) -> Content) {
        self.date = date
        self.degrees = degrees
        self.weatherType = weatherType
        self.columns = columns
        self.windSpeed = windSpeed
        self.content = content
    }
}

//
//  WeatherDailyForecastViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 10/10/21.
//

import Foundation
import SwiftUI

final class WeatherDailyForecastViewModel: ObservableObject {
    @Published var date: [String] = []
    @Published var degrees: [Temperature] = []
    @Published var weatherType: [WeatherDescription] = []
    @Published var windSpeed: [Float] = []
    
    func bindWeatherData() {
        Api().getData { (data) in
            let timeZone = TimeZone(identifier: data.timezone)
            
            for i in 0..<data.daily.count {
                self.date.append(Double(data.daily[i].dt).getDateFromUTC(timeZone: timeZone!))
                self.degrees.append(data.daily[i].temp)
                self.weatherType.append(contentsOf: data.daily[i].weather)
                self.windSpeed.append(data.daily[i].wind_speed)
            }
        }
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

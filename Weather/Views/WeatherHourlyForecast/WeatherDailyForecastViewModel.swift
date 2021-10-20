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
    
    func bindWeatherData() {
        var weatherFromData: WeatherData?
        
        
        Api().getData { (data) in
            weatherFromData = data
            let timeZone = TimeZone(identifier: data.timezone)
            
            self.date.append(Double(data.daily[0].dt).getDateFromUTC(timeZone: timeZone!))
            self.degrees.append(data.daily[0].temp)
            self.weatherType.append(contentsOf: data.daily[0].weather)
        }
        
        print("ДА ВОТ ЖЕЖ \(self.degrees)")
    }
}

struct DailyForecast<Content: View>: View {
    let date: [String]
    let degrees: [Temperature]
    let weatherType: [WeatherDescription]
    let columns: Int
    let content: ([String], [Temperature], [WeatherDescription], Int) -> Content
    
    var body: some View {
        HStack {
            ForEach(0 ..< self.columns) { column in
                self.content(date, degrees, weatherType, column)
                    .font(.system(size: 20, weight: .semibold, design: .default))
            }
        }
    }
    
    init(date: [String], degrees: [Temperature], weatherType: [WeatherDescription], columns: Int, @ViewBuilder content: @escaping ([String], [Temperature], [WeatherDescription], Int) -> Content) {
        self.date = date
        self.degrees = degrees
        self.weatherType = weatherType
        self.columns = columns
        self.content = content
    }
}

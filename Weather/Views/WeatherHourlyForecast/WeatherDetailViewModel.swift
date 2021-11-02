//
//  WeatherDetailViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 10/10/21.
//

import Foundation
import SwiftUI

final class WeatherDetailViewModel: ObservableObject {
    @Published var temperature: String?
    @Published var weather: String?
    @Published var windSpeed: Float?
    
    /*
    func bindWeatherData() {
        Api().getData() { (data) in
            self.temperature = String(format: "%.0f", data.current.temp)
            self.temperature?.append("ºC")
            self.weather = data.current.weather[0].main
            self.windSpeed = data.current.wind_speed
        }
    }
    */
    

}

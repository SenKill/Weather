//
//  SettingsViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 1/1/22.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    let units: [String: String] = ["metric": "Celsius, metre/s.", "imperial": "Fahrenheit, miles/h"]
    @Published var selectedUnit = "metric"
    @Published var language = Language.en
    
    init() {
        selectedUnit = UserDefaults.standard.string(forKey: "unit")!
    }
}

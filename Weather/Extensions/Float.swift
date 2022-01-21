//
//  Float.swift
//  Weather
//
//  Created by Serik Musaev on 12/9/21.
//

import Foundation

extension Float {
    var units: String {
        return UserDefaults.standard.string(forKey: "unit") ?? "metric"
    }
    
    func tempToString(_ withLetter: Bool) -> String {
        let temp = self
        var result: String = String(format: "%.0f", temp)
        result += "º"
        
        if units == "imperial" && withLetter {
            result += "F"
        }
        return result
    }
    
    func windToString() -> String {
        let wind = self
        var result: String = String(format: "%.1f", wind)
    
        if units == "metric" {
            result += "m/s".localized()
        } else {
            result += "mph".localized()
        }
        
        return result
    }
}

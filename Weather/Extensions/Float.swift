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
    
    func tempToString() -> String {
        let temp = self
        var result: String = String(format: "%.0f", temp)
        
        if units == "metric" {
            result += "º"
        } else {
            result += "ºF"
        }
        return result
    }
    
    func windToString() -> String {
        let wind = self
        var result: String = String(format: "%.1f", wind)
    
        if units == "metric" {
            result += " m/s"
        } else {
            result += " Mph"
        }
        
        return result
    }
}

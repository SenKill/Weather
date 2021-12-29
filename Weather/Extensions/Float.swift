//
//  Float.swift
//  Weather
//
//  Created by Serik Musaev on 12/9/21.
//

import Foundation

extension Float {
    func tempToString() -> String {
        let temp = self
        let result: String = String(format: "%.0f", temp) + "º"
        return result
    }
    
    func windToString() -> String {
        let wind = self
        let result: String = String(format: "%.1f", wind) + " m/s"
        return result
    }
}

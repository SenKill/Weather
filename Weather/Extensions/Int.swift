//
//  Int.swift
//  Weather
//
//  Created by Serik Musaev on 1/3/22.
//

import Foundation

extension Int {
    var addUnits: String {
        return String(self) + "hpa".localized()
    }
}

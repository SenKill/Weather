//
//  Int.swift
//  Weather
//
//  Created by Serik Musaev on 1/3/22.
//

import Foundation

extension Int32 {
    var addUnits: String {
        return String(self) + "hpa".localized()
    }
}

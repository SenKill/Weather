//
//  String.swift
//  Weather
//
//  Created by Serik Musaev on 1/2/22.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
}

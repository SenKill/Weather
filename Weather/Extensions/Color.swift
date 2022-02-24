//
//  Color.swift
//  Weather
//
//  Created by Serik Musaev on 12/3/21.
//

import Foundation
import SwiftUI

extension Color {
    init(r: Double, g: Double, b: Double) {
        self.init(red: r/255, green: g/255, blue: b/255)
    }
    
    static let theme = ColorTheme()
}

class ColorTheme {
    let background = Color("BackgroundColor")
    let defaultBackground = Color("DefaultBackground")
}

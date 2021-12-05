//
//  UIApplication.swift
//  Weather
//
//  Created by Serik Musaev on 12/4/21.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

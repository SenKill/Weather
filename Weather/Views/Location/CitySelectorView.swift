//
//  CitySelectorView.swift
//  Weather
//
//  Created by Serik Musaev on 12/8/21.
//

import SwiftUI

struct CitySelectorLoadingView: View {
    @Binding var country: Country?
    
    var body: some View {
        ZStack {
            if let country = country {
                CitySelectorView(country: country)
            }
        }
    }
}

struct CitySelectorView: View {
    let country: Country
    
    init(country: Country) {
        self.country = country
        print("Initializing \(country.title)")
    }
    
    var body: some View {
        Text(country.title)
    }
}

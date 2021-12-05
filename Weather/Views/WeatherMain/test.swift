//
//  test.swift
//  Weather
//
//  Created by Serik Musaev on 11/23/21.
//

import SwiftUI

struct DemoNavigateFromMenu: View {
    @State private var language = Language.en
    @State private var countries: [LocationItems] = []
    
    var body: some View {
        VStack {
            List(countries) { country in
                Text(country.title)
            }
            .onAppear {
                LocationData().getCountries(language: language.rawValue) { (countries) in
                    self.countries = countries
                }
            }
        }
    }
}



struct DemoNavigateFromMenu_Previews: PreviewProvider {
    static var previews: some View {
        DemoNavigateFromMenu()
    }
}

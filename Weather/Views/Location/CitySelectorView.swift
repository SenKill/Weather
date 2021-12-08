//
//  CitySelectorView.swift
//  Weather
//
//  Created by Serik Musaev on 12/8/21.
//

import SwiftUI

struct CitySelectorView: View {
    let country: String
    
    init(country: String) {
        self.country = country
        print("Initializing\(country)")
    }
    
    var body: some View {
        Text(country)
    }
}

struct CitySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        CitySelectorView(country: "Kazakhstan")
    }
}

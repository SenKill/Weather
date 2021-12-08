//
//  LocationView.swift
//  Weather
//
//  Created by Serik Musaev on 12/4/21.
//

import SwiftUI

struct LocationView: View {
    @ObservedObject private var viewModel = LocationViewModel()
    
    init() {
        // User defaults language settings
        viewModel.getCountriesData(lang: "en")
    }
    
    var body: some View {
        ZStack {
            VStack {
                SearchBarView(searchText: $viewModel.searchText)
                    .padding([.top, .leading, .trailing], 15)
                List(viewModel.countries) { country in
                    Text(country.title)
                }
            }
        }
        .navigationBarTitle("Select country", displayMode: .automatic)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}

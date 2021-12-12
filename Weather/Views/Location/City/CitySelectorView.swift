//
//  CitySelectorView.swift
//  Weather
//
//  Created by Serik Musaev on 12/8/21.
//

import SwiftUI

struct CitySelectorLoadingView: View {
    @ObservedObject private var viewModel = CitySelectorViewModel()
    let country: Country?
    
    init(country: Country?) {
        self.country = country
        if let country = country {
            viewModel.country = country
            viewModel.getCitiesData(lang: "en", id: country.id, query: nil, count: 50)
        }
    }
    
    var body: some View {
        ZStack {
            if viewModel.cities != [] {
                CitySelectorView(viewModel: viewModel)
            } else {
                LoadingView()
            }
        }
    }
}

struct CitySelectorView: View {
    @ObservedObject var viewModel: CitySelectorViewModel
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $viewModel.searchText)
            List(viewModel.cities) { city in
                Text(city.title)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.defaultBackground)
            }

        }
        .navigationTitle(viewModel.country!.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

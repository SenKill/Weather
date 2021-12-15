//
//  CitySelectorView.swift
//  Weather
//
//  Created by Serik Musaev on 12/8/21.
//

import SwiftUI

struct CitySelectorLoadingView: View {
    @ObservedObject private var viewModel = CitySelectorViewModel()
    
    init(country: Country?) {
        if let country = country {
            viewModel.country = country
            viewModel.getCitiesStart(lang: "en", id: country.id, query: nil, count: 50)
        }
    }
    
    var body: some View {
        ZStack {
            if viewModel.allCities != [] {
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
            SearchBarView(searchText: $viewModel.citySearchText)
            List(viewModel.cities) { city in
                Text(city.title)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.defaultBackground)
            }
        }
        .navigationTitle(viewModel.country!.title)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            print(viewModel.country?.title ?? "Some country", "is being dissapear!")
            for i in viewModel.cityCancellables {
                i.cancel()
            }
            viewModel.cityCancellables.removeAll()
        }
    }
}

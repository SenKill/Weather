//
//  CountrySelectorView.swift
//  Weather
//
//  Created by Serik Musaev on 12/4/21.
//

import SwiftUI

struct CountrySelectorView: View {
    @ObservedObject private var viewModel: LocationViewModel = LocationViewModel()
    
    @State private var showCityView: Bool = false
    @State private var selectedCountry: Country? = nil
    
    init() {
        // User defaults language settings
        viewModel.getCountriesData(lang: "en")
    }
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $viewModel.searchText)
                .padding([.top, .leading, .trailing], 15)
            List(viewModel.countries) { country in
                Text(country.title)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.theme.defaultBackground
                    )
                    .onTapGesture {
                        segue(country: country)
                    }
            }
        }
        .navigationTitle("Select country")
        .navigationBarTitleDisplayMode(.automatic)
        .background(
            NavigationLink(
                destination: CitySelectorLoadingView(country: $selectedCountry),
                isActive: $showCityView,
                label: { EmptyView() }
            )
        )
    }
    
    private func segue(country: Country) {
        selectedCountry = country
        showCityView.toggle()
    }
}

struct CountrySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectorView()
    }
}

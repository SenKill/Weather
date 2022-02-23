//
//  CountrySelectorView.swift
//  Weather
//
//  Created by Serik Musaev on 12/4/21.
//

import SwiftUI

struct CountrySelectorView: View {
    @StateObject private var viewModel = CountrySelectorViewModel()
    @State var groupedCountries: [String: [String]] = [:]
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $viewModel.countrySearchText)
            List {
                ForEach(viewModel.groupedCountries.keys.sorted(), id: \.self) { key in
                    Section(header: Text(key)) {
                        ForEach(viewModel.groupedCountries[key]!) { country in
                            Text(country.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    Color.theme.defaultBackground
                                )
                                .onTapGesture {
                                    segue(country: country)
                                }
                        }
                    }
                }
            }
            .navigationTitle("selectCountry")
            .navigationBarTitleDisplayMode(.automatic)
            .background(
                NavigationLink(
                    destination: CitySelectorLoadingView(country: viewModel.selectedCountry, showLoadingView: $viewModel.showLoadingView),
                    isActive: $viewModel.showLoadingView,
                    label: { EmptyView() }
                )
            )
        }
    }
    
    private func segue(country: Country) {
        viewModel.selectedCountry = country
        viewModel.showLoadingView = true
    }
}

struct CountrySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectorView()
    }
}

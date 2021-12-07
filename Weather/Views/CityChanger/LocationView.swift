//
//  LocationView.swift
//  Weather
//
//  Created by Serik Musaev on 12/4/21.
//

import SwiftUI

struct LocationView: View {
    @ObservedObject private var viewModel = LocationViewModel()
    
    var body: some View {
        ZStack {
            /*Color.theme.background
                .ignoresSafeArea()*/
            VStack {
                SearchBarView(searchText: $viewModel.searchText, isTapX: $viewModel.isTapX)
                    .padding()
                List(viewModel.countries) { country in
                    Text(country.title)
                }
            }
            .onAppear {
                viewModel.getCountriesData(lang: "en")
            }
        }
        .navigationTitle("Select country")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}

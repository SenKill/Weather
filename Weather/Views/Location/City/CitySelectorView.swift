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
    
    @State private var showAlert = false
    @State private var navigateToMain = false
    @State private var selectedCity: City?
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $viewModel.citySearchText)
            List(viewModel.cities) { city in
                Text(city.title)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.defaultBackground)
                    .onTapGesture {
                        selectedCity = city
                        showAlert.toggle()
                    }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("You selected city - \(selectedCity?.title ?? "nil"),\n this will update weather and city"),
                    primaryButton: .default(Text("OK")) {
                        navigateToMain.toggle()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationTitle(viewModel.country!.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(
            NavigationLink(
                destination: WeatherMainLoadingView(city: selectedCity).navigationBarHidden(true),
                isActive: $navigateToMain,
                label: { EmptyView() })
        )
        .onDisappear {
            print(viewModel.country?.title ?? "Some country", "is being dissapear!")
            for i in viewModel.cityCancellables {
                i.cancel()
            }
            viewModel.cityCancellables.removeAll()
        }
    }
}

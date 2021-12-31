//
//  CitySelectorView.swift
//  Weather
//
//  Created by Serik Musaev on 12/8/21.
//

import SwiftUI

struct CitySelectorLoadingView: View {
    @EnvironmentObject private var viewModel: CitySelectorViewModel
    let country: Country?
    @Binding var showLoadingView: Bool
    
    var body: some View {
        ZStack {
            LoadingView()
                .onAppear {
                    if let country = country {
                        viewModel.country = country
                        viewModel.getCitiesStart(lang: "en", id: country.id, query: nil, count: 50)
                    }
                }
                .onReceive(viewModel.$allCities, perform: { _ in
                    viewModel.showCityView = true
                })
                .sheet(isPresented: $viewModel.showCityView, onDismiss: {
                    showLoadingView = false
                }, content: {
                    CitySelectorView(viewModel: viewModel)
                })
                .background(
                    NavigationLink(
                        destination: WeatherMainLoadingView(city: viewModel.selectedCity).navigationBarHidden(true),
                        isActive: $viewModel.navigateToMain,
                        label: { EmptyView() }
                    )
                )
                .onDisappear {
                    viewModel.selectedCity = nil
                    viewModel.showCityView = false
                    viewModel.navigateToMain = false
                    viewModel.showAlert = false
                }
        }
        .navigationBarHidden(true)
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
                    .onTapGesture {
                        viewModel.selectedCity = city
                        viewModel.showAlert.toggle()
                    }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("You selected city - \(viewModel.selectedCity?.title ?? "nil"),\n this will update weather and city"),
                    primaryButton: .default(Text("OK")) {
                        viewModel.selectedCity?.region = viewModel.country?.title
                        
                        viewModel.navigateToMain = true
                        viewModel.showCityView = false
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

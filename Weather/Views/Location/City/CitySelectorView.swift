//
//  CitySelectorView.swift
//  Weather
//
//  Created by Serik Musaev on 12/8/21.
//

import SwiftUI

struct CitySelectorLoadingView: View {
    @StateObject private var viewModel = CitySelectorViewModel()
    let country: Country?
    @Binding var showLoadingView: Bool
    
    var body: some View {
        ZStack {
            LoadingView()
                .onAppear {
                    if let country = country {
                        viewModel.country = country
                        viewModel.getCitiesStart(id: country.id, query: nil, count: 50)
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
        }
        .navigationBarHidden(true)
    }
}

struct CitySelectorView: View {
    @ObservedObject var viewModel: CitySelectorViewModel
    
    var body: some View {
        VStack {
            HStack {
                SearchBarView(searchText: $viewModel.citySearchText)
                Button {
                    viewModel.showCityView = false
                } label: {
                    Text("Cancel")
                }
                .padding(EdgeInsets.init(top: 10, leading: 0, bottom: 0, trailing: 10))
            }
            List(viewModel.cities) { city in
                Text(city.title)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.defaultBackground)
                    .onTapGesture {
                        viewModel.selectCity(city: city)
                    }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.selectedCity?.title ?? "nil"),
                    message: Text("cityAlertMessage"),
                    primaryButton: .default(Text("OK")) {
                        viewModel.changeCity()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

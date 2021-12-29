//
//  CitySelectorView.swift
//  Weather
//
//  Created by Serik Musaev on 12/8/21.
//

import SwiftUI

struct CitySelectorLoadingView: View {
    @ObservedObject private var viewModel = CitySelectorViewModel()
    @State var showCityView: Bool = false
    @Binding var showLoadingView: Bool
    
    init(country: Country?, showLoadingView: Binding<Bool>) {
        self._showLoadingView = showLoadingView
        if let country = country {
            viewModel.country = country
            viewModel.getCitiesStart(lang: "en", id: country.id, query: nil, count: 50)
        }
    }
    
    var body: some View {
        ZStack {
            LoadingView()
                .onReceive(viewModel.$allCities, perform: { _ in
                    showCityView = true
                })
                .sheet(isPresented: $showCityView) {
                    NavigationView {
                        CitySelectorView(viewModel: viewModel, showLoadingView: $showLoadingView, showCityView: $showCityView)
                    }
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CitySelectorView: View {
    @ObservedObject var viewModel: CitySelectorViewModel
    
    @Binding var showLoadingView: Bool
    @Binding var showCityView: Bool

    @State private var navigateToMain = false
    @State private var showAlert = false
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
                        selectedCity?.region = viewModel.country?.title
                        navigateToMain = true
                        
                        showCityView = false
                        showLoadingView = false
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
            showLoadingView = false
        }
    }
}

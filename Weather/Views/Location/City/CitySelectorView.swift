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
            viewModel.getCitiesData(lang: "en", id: country.id, query: nil, count: 30)
        }
    }
    
    var body: some View {
        ZStack {
            if let country = country {
                CitySelectorView(viewModel: viewModel, country: country)
            } else {
                LoadingView()
            }
        }
    }
}

struct CitySelectorView: View {
    @ObservedObject var viewModel: CitySelectorViewModel
    let country: Country
    
    var body: some View {
        Text(country.title)
    }
}

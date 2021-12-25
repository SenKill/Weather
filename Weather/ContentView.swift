//
//  ContentView.swift
//  Weather
//
//  Created by Serik Musaev on 10/2/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = WeatherMainViewModel()
    
    var body: some View {
        WeatherMainLoadingView(city: nil)
            .environmentObject(viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

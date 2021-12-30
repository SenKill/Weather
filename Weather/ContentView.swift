//
//  ContentView.swift
//  Weather
//
//  Created by Serik Musaev on 10/2/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var mainViewModel = WeatherMainViewModel()
    @ObservedObject private var cityViewModel = CitySelectorViewModel()
    
    var body: some View {
        WeatherMainLoadingView(city: nil)
            .environmentObject(mainViewModel)
            .environmentObject(cityViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

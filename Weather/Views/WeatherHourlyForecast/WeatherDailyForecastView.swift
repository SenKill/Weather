//
//  WeatherDailyForecastView.swift
//  Weather
//
//  Created by Serik Musaev on 10/9/21.
//

import SwiftUI

struct WeatherDailyForecastView: View {
    @ObservedObject private var viewModel = WeatherDailyForecastViewModel()
    
    var body: some View {

        Text("xd")

    }
}

struct WeatherIcon_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDailyForecastView()
    }
}

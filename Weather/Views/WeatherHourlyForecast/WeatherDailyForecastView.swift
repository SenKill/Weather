//
//  WeatherDailyForecastView.swift
//  Weather
//
//  Created by Serik Musaev on 10/9/21.
//

import SwiftUI

struct WeatherDailyForecastView: View {
    // Not necessery parameters, delete them when Model and API will be done
    @ObservedObject private var viewModel = WeatherDailyForecastViewModel()
    
    var body: some View {

        
        VStack(alignment: .leading) {
            Text("8 days forecast")
                .onAppear() {
                    viewModel.bindWeatherData()
                }
                .font(.title)
            if viewModel.date != [] {
                ScrollView(.horizontal) {
                    DailyForecast(date: viewModel.date, degrees: viewModel.degrees, weatherType: viewModel.weatherType, windSpeed: viewModel.windSpeed, columns: viewModel.weatherType.count) { date, temp, weather, wind, col  in
                        VStack {
                            Text(date[col])
                            Image(weather[col].main)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50, alignment: .center)
                            Text("\(String(format: "%.1f",viewModel.degrees[col].day))°")
                            Text("\(String(format: "%.1f", wind[col]))m/s")
                        }
                        .padding(.trailing)
                    }
                }
            }
        }
        .padding()
    }
}

struct WeatherIcon_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDailyForecastView()
    }
}

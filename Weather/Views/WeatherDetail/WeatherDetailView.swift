//
//  WeatherDetailView.swift
//  Weather
//
//  Created by Serik Musaev on 10/2/21.
//

import SwiftUI



struct WeatherDetailView: View {
    
    @ObservedObject private var viewModel = WeatherDailyForecastViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                viewModel.setGradient(weather: viewModel.cweather ?? "Clear")
                   .ignoresSafeArea()
                VStack {
                    Text(viewModel.cweather ?? "Clear")
                        .font(.system(size: 30,
                                      weight: .bold,
                                      design: .default)
                        )
                    Text("Kostanay, Kazakhstan") // Need location data and convert it coordinates to a city and a country name
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                        .onAppear() {
                            viewModel.bindWeatherData()
                        }
                    Text(viewModel.ctemperature ?? "10ºC")
                        .fontWeight(.heavy)
                        .font(.system(size: 60,
                                      weight: .heavy,
                                      design: .default)
                        )
                    Spacer()
                }
            }
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
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView()
    }
}

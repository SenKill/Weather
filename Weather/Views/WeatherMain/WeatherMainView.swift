//
//  WeatherMainView.swift
//  Weather
//
//  Created by Serik Musaev on 10/2/21.
//

import SwiftUI

// TODO: Hourly forecast

// TODO: City selector

// TODO: Auto geolocation

struct WeatherMainView: View {
    
    @ObservedObject private var viewModel = WeatherMainViewModel()
    
    var body: some View {
        if viewModel.date == [] {
            LoadingScreen()
                .onAppear() {
                    viewModel.bindWeatherData()
                }
        } else {
            VStack {
                ZStack {
                    viewModel.setGradient(weather: viewModel.cWeather!)
                       .ignoresSafeArea()
                    VStack {
                        Text(viewModel.cWeather!)
                            .font(.system(size: 30,
                                          weight: .bold,
                                          design: .default)
                            )
                        Text(viewModel.cityName ?? "nil") // TODO: User can change his city
                            .padding(.bottom, 10)
                            .padding(.top, 5)
                            
                        Text(viewModel.cTemperature!)
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
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMainView()
    }
}

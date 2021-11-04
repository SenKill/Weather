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
                            HStack {
                                ForEach(0 ..< viewModel.weatherType.count) { col in
                                    VStack {
                                        Text(viewModel.date[col])
                                        Image(viewModel.weatherType[col].main)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 65, height: 65, alignment: .center)
                                        HStack {
                                            Text("\(String(format: "%.1f",viewModel.degrees[col].day))°")
                                            Text("\(String(format: "%.1f",viewModel.degrees[col].night))°")
                                        }
                                        Text("\(String(format: "%.1f", viewModel.windSpeed[col]))m/s")
                                    }
                                    .padding(.trailing)
                                }
                                .font(.system(size: 20, weight: .semibold, design: .default))
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

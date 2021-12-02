//
//  WeatherMainView.swift
//  Weather
//
//  Created by Serik Musaev on 10/2/21.
//

import SwiftUI

// TODO: Pull to update feature

extension Color {
    init(r: Double, g: Double, b: Double) {
        self.init(red: r/255, green: g/255, blue: b/255)
    }
}

struct WeatherMainView: View {
    
    @ObservedObject private var viewModel = WeatherMainViewModel()
    
    var body: some View {
        if viewModel.lat == 0.0 || viewModel.lon == nil {
         LoadingScreen()
             .onAppear(perform: viewModel.getCoordinates)
        } else if viewModel.cityName == nil {
         LoadingScreen()
             .onAppear(perform: viewModel.bindWeatherData)
        } else {
            NavigationView {
                ZStack {
                    Color(r: 245, g: 245, b: 245)
                        .ignoresSafeArea()
                    ZStack {
                        // MARK: Background Image
                        Image(viewModel.currentWeather!.icon + "b")
                            .resizable()
                            .scaledToFit()
                            // .blur(radius: 2)
                            .offset(x: 200, y: -125)
                    }
                    VStack {
                        VStack {
                            HStack {
                                VStack {
                                    Text(viewModel.currentDate!) // Current date
                                    Text(viewModel.cityName!)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                }
                                Spacer()
                                // MARK: Settings
                                NavigationLink(
                                    destination: SettingsView(),
                                    label: {
                                        Image(systemName: "gearshape.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(minWidth: 30, idealWidth: 35, maxWidth: 40, minHeight: 30, idealHeight: 35, maxHeight: 40, alignment: .center)
                                })
                            }
                            .padding()
                            HStack {
                                Text(viewModel.currentTemperature!)
                                    .font(.system(size: 80,
                                                  weight: .semibold,
                                                  design: .default))
                                Rectangle()
                                    .frame(width: 3, height: 100, alignment: .center)
                                VStack(alignment: .leading) {
                                    Group {
                                        Text(viewModel.currentWeather!.description)
                                        Text("H: \(String(format: "%.0f" ,viewModel.dailyTemperature[0].max))º")
                                        Text("L: \(String(format: "%.0f" ,viewModel.dailyTemperature[0].min))º")
                                    }
                                    .font(.system(size: 20, weight: .medium, design: .default))
                                    .padding(2)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                        HStack {
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Wind")
                                        Text("Humidity")
                                        Text("Feels like")
                                        Text("Pressure")
                                    }
                                    .font(.title3)
                                    .padding(0.5)
                                    .foregroundColor(Color(r: 151, g: 151, b: 153))
                                    VStack(alignment: .leading) {
                                        Text("\(viewModel.currentWind!)m/s")
                                        Text("\(viewModel.currentHumidity!)%")
                                        Text("\(viewModel.currentTemperatureFeels!)º")
                                        Text("\(viewModel.currentPressure!)mbar")
                                    }
                                    .font(.title3)
                                    .padding(0.5)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        Spacer()
                        Divider()
                        HourlyForecastView(viewModel: self.viewModel)
                        Divider()
                        DailyForecastView(viewModel: self.viewModel)
                    }
                }
                .foregroundColor(Color.init(r: 55, g: 55, b: 55))
                .navigationBarTitle("Back")
                .navigationBarHidden(true)
            }
        }
    }
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMainView()
    }
}

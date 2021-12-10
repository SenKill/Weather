//
//  WeatherMainView.swift
//  Weather
//
//  Created by Serik Musaev on 10/2/21.
//

import SwiftUI

// TODO: Pull to update feature

struct WeatherMainLoadingView: View {
    @EnvironmentObject private var viewModel: WeatherMainViewModel
    
    var body: some View {
        if viewModel.lat == 0.0 || viewModel.lon == nil {
            LoadingView()
        } else if viewModel.cityName.isEmpty {
            LoadingView()
                .onAppear { viewModel.bindWeatherData(lat: viewModel.lat!, lon: viewModel.lon!) }
        } else {
            WeatherMainView()
                .environmentObject(self.viewModel)
        }
    }
}

struct WeatherMainView: View {
    @EnvironmentObject private var viewModel: WeatherMainViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                ZStack {
                    // MARK: Background Image
                    Image(viewModel.current!.weather[0].icon + "b")
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 1)
                        .offset(x: 200, y: -125)
                }
                VStack {
                    VStack {
                        HStack {
                            VStack {
                                Text(Double(viewModel.current!.dt).getDateCurrent(timeZone: viewModel.timeZone!))
                                Text(viewModel.cityName)
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
                            Text(viewModel.current!.temp.tempToString())
                                .font(.system(size: 80,
                                              weight: .semibold,
                                              design: .default))
                            Rectangle()
                                .frame(width: 3, height: 100, alignment: .center)
                            VStack(alignment: .leading) {
                                Group {
                                    Text(viewModel.current!.weather[0].description)
                                    Text("H:" + viewModel.daily[0].temp.max.tempToString())
                                    Text("L:" + viewModel.daily[0].temp.min.tempToString())
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
                                .foregroundColor(Color.secondary)
                                VStack(alignment: .leading) {
                                    Text(viewModel.current!.wind_speed.windToString())
                                    Text("\(viewModel.current!.humidity)%")
                                    Text(viewModel.current!.feels_like.tempToString())
                                    Text("\(viewModel.current!.pressure)mbar")
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
                    HourlyForecastView()
                    Divider()
                    DailyForecastView()
                }
            }
            .foregroundColor(Color.primary)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMainView()
    }
}

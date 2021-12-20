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
    @State var isUpdating: Bool
    let city: City?
    
    var body: some View {
        if isUpdating {
            LoadingView()
                .onAppear {
                    viewModel.cityName = ""
                    viewModel.coordinate = nil
                    viewModel.getCoordinates()
                    isUpdating = false
                }
        } else {
            if let city: City = city {
                if viewModel.coordinate != nil {
                    LoadingView()
                        .onAppear {
                            viewModel.coordinate = nil
                        }
                }
                else if viewModel.coordinate == nil {
                    LoadingView()
                        .onAppear {
                            viewModel.cityName = ""
                            viewModel.cityToCoordinates(city: city)
                        }
                } else if viewModel.cityName.isEmpty {
                    LoadingView()
                        .onAppear { viewModel.bindWeatherData(coordinate: viewModel.coordinate!) }
                } else {
                    WeatherMainView()
                        .environmentObject(viewModel)
                }
            }
            
            else {
                if viewModel.coordinate == nil || viewModel.coordinate?.latitude == 0.0 || viewModel.cityName.isEmpty {
                    LoadingView()
                        .onReceive(viewModel.$coordinate) { (coordinate) in
                            if let coordinate = coordinate {
                                if coordinate.latitude != 0.0 {
                                    viewModel.bindWeatherData(coordinate: coordinate)
                                }
                            }
                        }
                        // MARK: USE .on methods
                } else {
                    WeatherMainView()
                        .environmentObject(viewModel)
                }
            }
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
                                    .frame(minWidth: 25, idealWidth: 30, maxWidth: 35, minHeight: 25, idealHeight: 30, maxHeight: 35, alignment: .center)
                                    .foregroundColor(Color.primary)
                            })
                    }
                    .padding()
                    HStack {
                        VStack {
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
                                        Text("H: " + viewModel.daily[0].temp.max.tempToString())
                                        Text("L: " + viewModel.daily[0].temp.min.tempToString())
                                    }
                                    .font(.system(size: 20, weight: .medium, design: .default))
                                    .padding(2)
                                }
                                Spacer()
                            }
                            .padding(.bottom)
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
                                        .foregroundColor(Color.secondary)
                                        VStack(alignment: .leading) {
                                            Text(viewModel.current!.wind_speed.windToString())
                                            Text("\(viewModel.current!.humidity)%")
                                            Text(viewModel.current!.feels_like.tempToString())
                                            Text("\(viewModel.current!.pressure)mbar")
                                        }
                                        .font(.title3)
                                    }
                                }
                                Spacer()
                            }
                        }
                        .background(
                            // MARK: Background Image
                            Image(viewModel.current!.weather[0].icon + "b")
                                .resizable()
                                .scaledToFill()
                                .offset(x: UIScreen.main.bounds.width / 3)
                        )
                    }
                    .padding()
                    Spacer()
                    Divider()
                    HourlyForecastView(hourly: viewModel.hourly, timeZone: viewModel.timeZone!)
                    Divider()
                    DailyForecastView(daily: viewModel.daily, timeZone: viewModel.timeZone!)
                }
            }
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

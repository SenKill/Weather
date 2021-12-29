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
    @State var city: City?
    @State var isUpdating: Bool? = nil
    
    var body: some View {
        if let city = city {
            LoadingView()
                .onAppear {
                    viewModel.loadData(withCity: city)
                    self.city = nil
                }
        } else if isUpdating != nil {
            LoadingView()
                .onAppear {
                    viewModel.loadData(withCity: nil)
                }
        } else if viewModel.isLoading {
            LoadingView()
        } else {
            WeatherMainView()
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
                            }
                        )
                    }
                    .zIndex(1)
                    .padding()
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
                        .padding(.vertical)
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
                                        Text("\(viewModel.current!.pressure) mbar")
                                    }
                                    .font(.title3)
                                }
                            }
                            Spacer()
                        }
                        .padding(.top)
                    }
                    .background(
                        // MARK: Background Image
                        Image(viewModel.current!.weather[0].icon + "b")
                            .resizable()
                            .scaledToFill()
                            .offset(x: UIScreen.main.bounds.width / 3)
                    )
                    .padding([.horizontal, .bottom])
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

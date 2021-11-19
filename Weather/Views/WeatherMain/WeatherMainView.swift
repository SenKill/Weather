//
//  WeatherMainView.swift
//  Weather
//
//  Created by Serik Musaev on 10/2/21.
//

import SwiftUI

// TODO: City selector

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
            ZStack {
                Color.init(r: 245, g: 245, b: 245)
                    .ignoresSafeArea()
                ZStack {
                    Image(viewModel.currentWeather!.icon + "b")
                        .resizable()
                        .scaledToFit()
                        // .blur(radius: 2)
                        .offset(x: 200, y: -100)
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
                            Button(action: viewModel.getCoordinates, label: { // TODO: Menu and it's call
                                Image(systemName: "list.dash")
                                    .resizable()
                                    .frame(width: 25, height: 20, alignment: .center)
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
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0 ..< viewModel.hourlyWeather.count) { column in
                                VStack(alignment: .center) {
                                    Text(viewModel.hourlyDate[column])
                                    Image(viewModel.hourlyWeather[column].icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60, alignment: .center)
                                    Text("\(String(format: "%.0f" ,viewModel.hourlyTemperature[column]))º")
                                        .font(.title3)
                                    Text("\(String(format: "%.1f" ,viewModel.hourlyWind[column]))m/s")
                                }
                                .padding(10)
                            }
                        }
                    }
                    .padding(.vertical)
                    Divider()
                    // TODO: Create another view and window for dailyForecast
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(0 ..< viewModel.dailyWeather.count) { column in
                            ZStack(alignment: .center) {
                                HStack {
                                    Text(viewModel.dailyDate[column])
                                    Spacer()
                                    HStack {
                                        Text("\(String(format: "%.0f",viewModel.dailyTemperature[column].day))°")
                                        Text("\(String(format: "%.0f",viewModel.dailyTemperature[column].night))°")
                                            .foregroundColor(Color.init(r: 150, g: 150, b: 150))
                                    }
                                }
                                Image(viewModel.dailyWeather[column].icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                    .padding([.leading, .trailing])
                }
                
            }
            .foregroundColor(Color.init(r: 55, g: 55, b: 55))
        }
    }
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMainView()
    }
}

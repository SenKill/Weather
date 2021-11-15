//
//  WeatherMainView.swift
//  Weather
//
//  Created by Serik Musaev on 10/2/21.
//

import SwiftUI

// TODO: Hourly forecast

// TODO: City selector

extension Color {
    init(r: Double, g: Double, b: Double) {
        self.init(red: r/255, green: g/255, blue: b/255)
    }
}

struct WeatherMainView: View {
    
    @ObservedObject private var viewModel = WeatherMainViewModel()
    
    // Replace theese with viewModel later
    let hourlyWeather = ["Clear", "Clear", "Clear", "Clouds", "Clouds", "Snow"]
    let hourlyTemperature = ["-5º", "-4º", "-2º", "-3º", "-4º", "-3º"]
    let hourlyTime = ["10:00", "11:00", "12:00", "13:00", "14:00", "15:00"]
    
    let dailyDate = ["14.11", "15.11", "16.11", "17.11", "18.11"]
    let dailyWeather = ["Clear", "Clouds", "Snow", "Snow", "Snow"]
    let dailyTemperatureDay = ["3º", "1º", "-2º", "-5º", "-3º"]
    let dailyTemperatureNight = ["0º", "-1º", "-4º", "-6º", "-8º"]
    
    // TODO: Change fonts!
    var body: some View {
        ZStack {
            Color.init(r: 245, g: 245, b: 245)
                .ignoresSafeArea()
            ZStack {
                Image("sunny")
                    .resizable()
                    .scaledToFit()
                    .blur(radius: 20)
                    .offset(x: 200, y: -100)
            }
            VStack {
                VStack {
                    HStack {
                        VStack {
                            Text("10:25 pm, Sat Nov 13")
                            Text("Kostanay")
                                .font(.title3)
                                .fontWeight(.medium)
                                
                        }
                        .padding(.leading)
                        Spacer()
                        Button(action: viewModel.getCoordinates, label: { // TODO: Menu and it's call
                            Image(systemName: "list.dash")
                                .resizable()
                                .frame(width: 25, height: 20, alignment: .center)
                        })
                        .padding()
                    }
                    HStack {
                        Text("-5º")
                            .font(.system(size: 80,
                                          weight: .semibold,
                                          design: .default))
                        Rectangle()
                            .frame(width: 3, height: 100, alignment: .center)
                        VStack(alignment: .leading) {
                            Group {
                                Text("Clear")
                                Text("H: -2º")
                                Text("L: -7º")
                            }
                            .font(.title2)
                            .padding(2)
                        }
                        Spacer()
                    }
                    .padding()
                }
                HStack {
                    VStack(alignment: .leading) {
                        Group {
                            Text("Wind")
                            Text("Humidity")
                            Text("Feels like")
                        }
                        .font(.title3)
                        .padding(0.5)
                        .foregroundColor(Color(r: 151, g: 151, b: 153))
                    }
                    .padding()
                    VStack(alignment: .leading) {
                        Group {
                            Text("5 m/s")
                            Text("91%")
                            Text("27º")
                        }
                        .font(.title3)
                        .padding(0.5)
                    }
                    .padding()
                    Spacer()
                }
                .padding(.top)
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0 ..< hourlyWeather.count) { column in
                            VStack(alignment: .center) {
                                Text(hourlyTime[column])
                                Image(hourlyWeather[column])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45, alignment: .center)
                                Text(hourlyTemperature[column])
                            }
                            .padding(10)
                        }
                    }
                }
                .padding()
                Divider()
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(0 ..< dailyWeather.count) { column in
                        HStack {
                            Text(dailyDate[column])
                            Spacer()
                            Image(dailyWeather[column])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30, alignment: .center)
                            Spacer()
                            HStack {
                                Text(dailyTemperatureDay[column])
                                Text(dailyTemperatureNight[column])
                                    .foregroundColor(Color(r: 150, g: 150, b: 150))
                            }
                        }
                    }
                }
                .padding([.leading, .trailing])
            }
            
        }
        .foregroundColor(Color.init(r: 55, g: 55, b: 55))
    }
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMainView()
    }
}


/*if viewModel.lat == 0.0 || viewModel.lon == nil {
 LoadingScreen()
     .onAppear(perform: viewModel.getCoordinates)
} else if viewModel.cityName == nil {
 LoadingScreen()
     .onAppear(perform: viewModel.bindWeatherData)
} else { */

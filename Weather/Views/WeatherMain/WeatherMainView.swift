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
    
    // TODO: Change fonts!
    var body: some View {
        ZStack {
            Color.init(r: 245, g: 245, b: 245)
                .ignoresSafeArea()
            ZStack {
                Image("Sunny")
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
                                Text("Sunny")
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
                HStack {
                    // TODO: Make scrolling view for hourly forecast
                }
                Spacer()
                VStack {
                    // TODO: Make scrolling for daily forecast
                }
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

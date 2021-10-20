//
//  WeatherDetailView.swift
//  Weather
//
//  Created by Serik Musaev on 10/2/21.
//

import SwiftUI



struct WeatherDetailView: View {
    // Remove these and get data from the API
    @State var currentWeather = "Clear"
    @State var currentTemperature = 10
    @State var location = "Kostanay, Kazakhstan"
    
    @StateObject private var viewModel = WeatherDetailViewModel()
    
    var body: some View {
        
        VStack {
            ZStack {
                viewModel.setGradient(weather: currentWeather)
                    .ignoresSafeArea()
                VStack() {
                    // These things also need to connect into the API and get data through the ViewModel
                    Text(currentWeather)
                        .font(.system(size: 30,
                                      weight: .bold,
                                      design: .default)
                        )
                    Text(location)
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                    Text("\(currentTemperature)º")
                        .fontWeight(.heavy)
                        .font(.system(size: 60,
                                      weight: .heavy,
                                      design: .default)
                        )
                    Spacer()
                }
            }
            WeatherDailyForecastView()
        }
    }
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView()
    }
}

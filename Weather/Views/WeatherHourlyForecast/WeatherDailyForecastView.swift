//
//  WeatherDailyForecastView.swift
//  Weather
//
//  Created by Serik Musaev on 10/9/21.
//

import SwiftUI

struct WeatherDailyForecastView: View {
    // Not necessery parameters, delete them when Model and API will be done
    @ObservedObject private var viewModel = WeatherDailyForecastViewModel()
    
    var body: some View {

        
        VStack(alignment: .leading) {
            Text("Today")
                .onAppear() {
                    viewModel.bindWeatherData()
                    print("ОНО ТУТА \(viewModel.degrees)")
                }
                .font(.title)
            
            DailyForecast(date: viewModel.date, degrees: viewModel.degrees, weatherType: viewModel.weatherType, columns: viewModel.weatherType.count) { date, temp, weath, col  in
                VStack {
                    Text(date[col])
                    Image(weath[col].main)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50, alignment: .center)
                    Text("\(temp[col].day)°")
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct WeatherIcon_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDailyForecastView()
    }
}

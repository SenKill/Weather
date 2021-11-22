//
//  HourlyForecastView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI

struct HourlyForecastView: View {
    @ObservedObject var viewModel: WeatherMainViewModel
    
    var body: some View {
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
    }
}

//
//  DailyForecastView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI

struct DailyForecastView: View {
    @EnvironmentObject private var viewModel: WeatherMainViewModel
    
    var body: some View {
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
                                .foregroundColor(Color.secondary)
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

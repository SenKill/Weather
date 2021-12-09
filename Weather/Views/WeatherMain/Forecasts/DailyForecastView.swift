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
            ForEach(0 ..< viewModel.daily.count) { column in
                ZStack(alignment: .center) {
                    HStack {
                        Text(Double(viewModel.daily[column].dt).getDateDaily(timeZone: viewModel.timeZone!))
                        Spacer()
                        HStack {
                            Text(viewModel.daily[column].temp.day.tempToString())
                            Text(viewModel.daily[column].temp.night.tempToString())
                                .foregroundColor(Color.secondary)
                        }
                    }
                    Image(viewModel.daily[column].weather[0].icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
            }
        }
        .padding([.leading, .trailing])
    }
}

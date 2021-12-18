//
//  HourlyForecastView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI

struct HourlyForecastView: View {
    @EnvironmentObject private var viewModel: WeatherMainViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0 ..< viewModel.hourly.count) { column in
                    VStack(alignment: .center) {
                        Text(Double(viewModel.hourly[column].dt).getDateHourly(timeZone: viewModel.timeZone!))
                        Image(viewModel.hourly[column].weather[0].icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60, alignment: .center)
                        Text(viewModel.hourly[column].temp.tempToString())
                            .font(.title3)
                        Text(viewModel.hourly[column].wind_speed.windToString())
                    }
                    .padding(10)
                }
            }
        }
    }
}

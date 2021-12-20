//
//  HourlyForecastView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI

struct HourlyForecastView: View {
    let hourly: [HourlyWeather]
    let timeZone: TimeZone
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0 ..< hourly.count) { column in
                    VStack(alignment: .center) {
                        Text(Double(hourly[column].dt).getDateHourly(timeZone: timeZone))
                        Image(hourly[column].weather[0].icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60, alignment: .center)
                        Text(hourly[column].temp.tempToString())
                            .font(.title3)
                        Text(hourly[column].wind_speed.windToString())
                    }
                    .padding(10)
                }
            }
        }
    }
}

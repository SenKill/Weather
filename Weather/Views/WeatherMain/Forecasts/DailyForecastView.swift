//
//  DailyForecastView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI

struct DailyForecastView: View {
    let daily: [DailyWeather]
    let timeZone: TimeZone
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(0 ..< daily.count) { column in
                ZStack(alignment: .center) {
                    HStack {
                        Text(Double(daily[column].dt).getDateDaily(timeZone: timeZone))
                        Spacer()
                        HStack {
                            Text(daily[column].temp.day.tempToString())
                            Text(daily[column].temp.night.tempToString())
                                .foregroundColor(Color.secondary)
                        }
                    }
                    Image(daily[column].weather[0].icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
            }
        }
        .padding([.leading, .trailing])
    }
}

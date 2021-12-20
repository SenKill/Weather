//
//  SwiftUIView.swift
//  Weather
//
//  Created by Serik Musaev on 12/20/21.
//

import SwiftUI

struct SwiftUIView: View {
    @EnvironmentObject private var viewModel: WeatherMainViewModel
    
    var body: some View {
        VStack {
            Image("10db")
                .resizable()
                .scaledToFit()
                .blur(radius: 1)
                .offset(x: UIScreen.main.bounds.width/2.5)
            HourlyForecastView(hourly: viewModel.hourly, timeZone: viewModel.timeZone!)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

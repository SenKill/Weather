//
//  SettingsView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        // TODO: Set up settings view
        List {
            NavigationLink(
                destination: CitySearchView(),
                label: {
                    Text("Change city")
            })
            Text("Second")
            Text("Third")
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

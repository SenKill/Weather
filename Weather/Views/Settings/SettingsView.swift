//
//  SettingsView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI
import Combine


struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        List {
            Section(header: Text("main")) {
                NavigationLink(
                    destination: CountrySelectorView(),
                    label: {
                        Text("changeCity")
                    }
                )

                HStack {
                    Picker(viewModel.units[viewModel.selectedUnit]!, selection: $viewModel.selectedUnit) {
                        Text("metric").tag("metric")
                        Text("imperial").tag("imperial")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: viewModel.selectedUnit) { unit in
                        UserDefaults.standard.set(unit, forKey: "unit")
                    }
                }
                
                NavigationLink(destination: WeatherMainLoadingView(city: nil, isUpdating: true).navigationBarHidden(true)) {
                    Label {
                        Text("updateLoc")
                    } icon: {
                        Image(systemName: "location.fill")
                    }
                }
            }
        }
        .navigationTitle("settings")
        .listStyle(InsetGroupedListStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

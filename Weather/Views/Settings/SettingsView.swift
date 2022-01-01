//
//  SettingsView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI
import Combine

// MARK: List of languages and Units
enum Language: String, CaseIterable, Identifiable {
    case en = "English"
    case ru = "Russian"
    
    var cleanValue: String {
        switch self {
        case .en: return "en"
        case .ru: return "ru"
        }
    }
    
    var id: String { self.rawValue }
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    // TODO: Localization to other languages
    var body: some View {
        List {
            Section(header: Text("Main")) {
                NavigationLink(
                    destination: CountrySelectorView(),
                    label: {
                        Text("Change city")
                    }
                )

                HStack {
                    Picker(viewModel.units[viewModel.selectedUnit]!, selection: $viewModel.selectedUnit) {
                        Text("Celsius, metre/s.").tag("metric")
                        Text("Fahrenheit, miles/h").tag("imperial")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: viewModel.selectedUnit) { unit in
                        UserDefaults.standard.set(unit, forKey: "unit")
                    }
                }
                
                NavigationLink(destination: WeatherMainLoadingView(city: nil, isUpdating: true).navigationBarHidden(true)) {
                    Label {
                        Text("Update your location")
                    } icon: {
                        Image(systemName: "location.fill")
                    }
                }
            }
            Section(header: Text("Other")) {
                HStack {
                    Text("Lanuage")
                    Spacer()
                    Picker(selection: $viewModel.language, label: Text(viewModel.language.rawValue), content: {
                        ForEach(Language.allCases) { localLanguage in
                            Text(localLanguage.rawValue).tag(localLanguage)
                        }
                    })
                    .pickerStyle(MenuPickerStyle())
                }
            }
        }
        .navigationTitle("Settings")
        .listStyle(InsetGroupedListStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

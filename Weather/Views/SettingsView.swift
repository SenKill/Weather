//
//  SettingsView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI

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

enum Units: String {
    case metric = "Celsius, metre/s."
    case imperial = "Fahrenheit, miles/h"
    
    var cleanValue: String {
        switch self {
        case .metric: return "metric"
        case .imperial: return "imperial"
        }
    }
}

struct SettingsView: View {
    @State private var units = Units.metric
    @State private var language = Language.en
    
    // TODO: Real language and units changing
    var body: some View {
        List {
            Section(header: Text("Main")) {
                NavigationLink(
                    destination: CountrySelectorView(),
                    label: {
                        Text("Change city")
                    })

                HStack {
                    Text("Units")
                    Spacer()
                    Picker(selection: $units, label: Text(units.rawValue), content: {
                        Text("Celsius, metre/s.").tag(Units.metric)
                        Text("Fahrenheit, miles/h").tag(Units.imperial)
                    })
                    .pickerStyle(MenuPickerStyle())
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
                    Picker(selection: $language, label: Text(language.rawValue), content: {
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

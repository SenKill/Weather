//
//  test.swift
//  Weather
//
//  Created by Serik Musaev on 11/23/21.
//

import SwiftUI

struct DemoNavigateFromMenu: View {
    @State private var navigateTo = ""
    @State private var isActive = false
    @State private var selectedView = ViewSelector.main
    
    var body: some View {
        NavigationView {
            Menu {
                Button("item1") {
                    self.selectedView = .settings
                    self.isActive = true
                }
                Button("item2") {
                    self.selectedView = .citySearch
                    self.isActive = true
                }
            } label: {
                Text("open menu")
            }
            .background(
                NavigationLink(destination: viewReturner(view: selectedView), isActive: $isActive) { })
        }
    }
}



struct DemoNavigateFromMenu_Previews: PreviewProvider {
    static var previews: some View {
        DemoNavigateFromMenu()
    }
}

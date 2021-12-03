//
//  SearchBarView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI

struct SearchBarView: View {
    @ObservedObject private var viewModel = SearchBarViewModel()
    
    var body: some View {
        
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.secondary)
        }
    }
}

struct CitySearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}

//
//  SearchBarView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ?
                        Color.secondary : Color.primary
                )
            TextField("sampleText".localized(), text: $searchText)
                .disableAutocorrection(true)
                .foregroundColor(Color.primary)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.primary)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    ,alignment: .trailing
                )
        }
        // MARK: Search bar cusomization
        .font(.headline)
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.defaultBackground)
                .shadow(
                    color: Color.primary.opacity(0.15),
                    radius: 10, x: 0, y: 0)
        )
        .padding([.top, .leading, .trailing], 15)
    }
}

struct CitySearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
        SearchBarView(searchText: .constant(""))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}

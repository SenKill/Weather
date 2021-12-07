//
//  SearchBarView.swift
//  Weather
//
//  Created by Serik Musaev on 11/22/21.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isTapX: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ?
                        Color.secondary : Color.primary
                )
            TextField("Write location here...", text: $searchText)
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
                            isClickedX.toggle()
                        }
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .frame(maxWidth: .infinity)
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.theme.defaultBackground)
                .shadow(
                    color: Color.primary.opacity(0.2),
                    radius: 3, x: 0, y: 0)
        )
    }
}

struct CitySearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""), isTapX: .constant(false))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
        SearchBarView(searchText: .constant(""), isTapX: .constant(false))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}

//
//  test.swift
//  Weather
//
//  Created by Serik Musaev on 11/23/21.
//

import SwiftUI

struct DemoNavigateFromMenu: View {
    @State private var language = Language.en
    
    var body: some View {
        VStack {
            Text(language.cleanValue)
            Button(action: {
                language = .ru
            }, label: {
                Text(language.rawValue)
            })
        }
    }
}



struct DemoNavigateFromMenu_Previews: PreviewProvider {
    static var previews: some View {
        DemoNavigateFromMenu()
    }
}

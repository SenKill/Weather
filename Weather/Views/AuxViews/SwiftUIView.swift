//
//  SwiftUIView.swift
//  Weather
//
//  Created by Serik Musaev on 11/8/21.
//

import SwiftUI

import Foundation

class LocationManagerr: NSObject, ObservableObject {
  @Published var someVar: Int = 0
}

struct SwiftUIView: View {
    @ObservedObject var lm = LocationManagerr()

    var someVar: String  { return("\(lm.someVar ?? 0)") }

    var body: some View {
        VStack {
            Text("someVar: \(self.someVar)")
            Button(action: { self.lm.someVar = self.lm.someVar + 2 }) {
              Text("Add more")
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

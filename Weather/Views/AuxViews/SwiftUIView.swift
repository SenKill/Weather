//
//  SwiftUIView.swift
//  Weather
//
//  Created by Serik Musaev on 11/8/21.
//

import SwiftUI
import Foundation
import CoreLocation

class ViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            // error
            return
        }
        
        DispatchQueue.main.async {
            self.coordinates = latestLocation.coordinate
        }
    }
}

struct SwiftUIView: View {
    @StateObject var viewModel = ViewModel()
    @State var coordinates: Double = 0.0

    var body: some View {
        Text("\(coordinates)")
            .onAppear() {
                self.coordinates = viewModel.coordinates.latitude
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

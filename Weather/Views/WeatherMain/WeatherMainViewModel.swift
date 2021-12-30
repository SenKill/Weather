//
//  WeatherMainViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 10/10/21.
//

import Foundation
import CoreLocation

final class WeatherMainViewModel: ObservableObject {
    @Published var timeZone: TimeZone?
    @Published var cityName: String = ""
    
    @Published var current: CurrentWeather?
    @Published var hourly: [HourlyWeather] = []
    @Published var daily: [DailyWeather] = []
    
    @Published var coordinate: CLLocationCoordinate2D? = nil
    @Published var isLoading: Bool = true
    @Published var test: Bool = false
    
    private var locationManager = LocationManager()
    
    init() {
        // TODO: Save latest data to UserDefaults or CoreData
        self.loadData(withCity: nil)
    }
    
    func loadData(withCity city: City?) {
        self.isLoading = true
        
        let queue = DispatchQueue(label: "networking.weatherdata")
        let coordinateWorkItem = DispatchWorkItem {
            if let someCity = city {
                self.cityToCoordinates(city: someCity)
            } else {
                self.getUserCoordinates()
            }
        }
        queue.async(execute: coordinateWorkItem)
    }
    
    private func bindWeatherData(coordinate: CLLocationCoordinate2D) {
        WeatherData().getData(latitude: String(coordinate.latitude), longtitude: String(coordinate.longitude)) { data in
            self.timeZone = TimeZone(identifier: data.timezone)
                    
            self.current = data.current
            self.hourly = data.hourly
            self.daily = data.daily
            
            self.coordinatesToCity(coordinates: coordinate)
        }
    }
    
    private func coordinatesToCity(coordinates: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Unable to Reverse Geocode Location (\(error.localizedDescription))")
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    guard let country = placemark.country else {
                        print("ERROR: Wrong coordinates")
                        return
                    }
                    let city = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.administrativeArea
                    self.cityName = (city ?? "City not found") + ", " + country
                    self.isLoading = false
                }
            }
        }
    }
    
    private func getUserCoordinates() {
        DispatchQueue.main.async {
            let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate: CLLocationCoordinate2D()
            self.coordinate = coordinate
            self.bindWeatherData(coordinate: coordinate)
        }
    }
    
    private func cityToCoordinates(city: City) {
        let geocoder = CLGeocoder()
        let adress = ("\(city.title), \(city.region ?? "")")
        geocoder.geocodeAddressString(adress) { (placemarks, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                if let coordinate = self.coordinate {
                    self.bindWeatherData(coordinate: coordinate)
                }
                return
                // TODO: Error handling when city cannot be find
            }
            if let placemark = placemarks?[0] {
                if let coordinates = placemark.location?.coordinate {
                    self.bindWeatherData(coordinate: coordinates)
                } else {
                    print("Error with converting city to coordinates")
                }
            }
        }
    }
}

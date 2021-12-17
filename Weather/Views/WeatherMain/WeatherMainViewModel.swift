//
//  WeatherMainViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 10/10/21.
//

import Foundation
import SwiftUI
import CoreLocation


// TODO: Save latest data to UserDefaults or CoreData
final class WeatherMainViewModel: ObservableObject {
    @Published var timeZone: TimeZone?
    @Published var cityName: String = ""
    
    @Published var current: CurrentWeather?
    @Published var hourly: [HourlyWeather] = []
    @Published var daily: [DailyWeather] = []
    
    @Published var coordinate: CLLocationCoordinate2D? = nil
    
    @ObservedObject private var locationManager = LocationManager()
    
    init() {
        getCoordinates()
    }
    
    func bindWeatherData(coordinate: CLLocationCoordinate2D) {
        WeatherData().getData(latitude: String(coordinate.latitude), longtitude: String(coordinate.longitude)) { data in
            self.timeZone = TimeZone(identifier: data.timezone)
                    
            self.current = data.current
            self.hourly = data.hourly
            self.daily = data.daily
            
            self.coordinatesToCity(coordinates: coordinate)
        }
    }
    
    func getCoordinates() {
        DispatchQueue.main.async {
            let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate: CLLocationCoordinate2D()
            self.coordinate = coordinate
        }
    }
    
    private func coordinatesToCity(coordinates: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Unable to Reverse Geocode Location (\(error))")
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    let country = placemark.country!
                    let city = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.administrativeArea
                    self.cityName = (city ?? "City not found") + ", " + country
                }
            }
        }
    }
    
    func cityToCoordinates(city: City) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city.title) { (placemarks, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let placemark = placemarks?[0] {
                let coordinates = placemark.location?.coordinate
                self.coordinate = coordinates
            }
        }
    }
    
    func setGradient(weather: String) -> LinearGradient? {
        var colors: [Color]
        switch weather {
        case "Clear":
            colors = [.white, .orange]
            break;
        case "Clouds":
            colors = [.white, .blue]
            break;
        case "Rain":
            colors = [.gray, .blue]
            break;
        default:
            print("ERROR: Wrong weather was inputed!(or i'm haven't wrote other cases yet))))")
            return nil
        }
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .topTrailing, endPoint: .bottom)
    }
}

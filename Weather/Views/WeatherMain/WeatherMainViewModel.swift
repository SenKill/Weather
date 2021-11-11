//
//  WeatherMainViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 10/10/21.
//

import Foundation
import SwiftUI
import CoreLocation

final class WeatherMainViewModel: ObservableObject {
    @Published var date: [String] = []
    @Published var degrees: [Temperature] = []
    @Published var weatherType: [WeatherDescription] = []
    @Published var windSpeed: [Float] = []
    
    @Published var lat: Double?
    @Published var lon: Double?
    
    @Published var cityName: String?
    @Published var cTemperature: String?
    @Published var cWeather: String?
    @Published var cWindSpeed: Float?
    
    @ObservedObject private var locationManager = LocationManager()
    
    func bindWeatherData() {
        Api().getData(latitude: String(self.lat!), longtitude: String(self.lon!)) { (data) in
            self.cTemperature = String(format: "%.0f", data.current.temp)
            self.cTemperature?.append("ºC")
            self.cWeather = data.current.weather[0].main
            self.cWindSpeed = data.current.wind_speed
                    
            self.getCityName(lat: self.lat!, lon: self.lon!)
                    
            let timeZone = TimeZone(identifier: data.timezone)
            for i in 0..<data.daily.count {
                self.date.append(Double(data.daily[i].dt).getDateFromUTC(timeZone: timeZone!))
                self.degrees.append(data.daily[i].temp)
                self.weatherType.append(contentsOf: data.daily[i].weather)
                self.windSpeed.append(data.daily[i].wind_speed)
            }
        }
    }
    
    func getCoordinates() {
        let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate: CLLocationCoordinate2D()
        self.lat = coordinate.latitude
        self.lon = coordinate.longitude
    }
    
    private func getCityName(lat: Double, lon: Double) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Unable to Reverse Geocode Location (\(error))")
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    let country = placemark.country!
                    let city = placemark.locality ?? placemark.administrativeArea
                    var subCity = placemark.subLocality
                    if subCity != nil {
                        subCity!.append(", ")
                    }
                    self.cityName = (subCity ?? "") + (city ?? "City not found") + ", " + country
                }
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

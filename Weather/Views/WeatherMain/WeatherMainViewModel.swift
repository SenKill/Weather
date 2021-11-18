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
    @Published var cityName: String?
    @Published var currentDate: String?
    @Published var currentTemperature: String?
    @Published var currentWeather: WeatherDescription?
    @Published var currentWind: String?
    @Published var currentHumidity: Int?
    @Published var currentTemperatureFeels: String?
    @Published var currentPressure: Int?
    
    @Published var hourlyDate: [String] = []
    @Published var hourlyTemperature: [Float] = []
    @Published var hourlyWeather: [WeatherDescription] = []
    @Published var hourlyWind: [Float] = []
    
    @Published var dailyDate: [String] = []
    @Published var dailyTemperature: [Temperature] = []
    @Published var dailyWeather: [WeatherDescription] = []
    @Published var dailyWind: [Float] = []
    
    @Published var lat: Double?
    @Published var lon: Double?
    

    
    @ObservedObject private var locationManager = LocationManager()
    
    func bindWeatherData() {
        Api().getData(latitude: String(self.lat!), longtitude: String(self.lon!)) { (data) in
            let timeZone = TimeZone(identifier: data.timezone)
            
            self.currentDate = Double(data.current.dt).getDateCurrent(timeZone: timeZone!)
            self.currentTemperature = String(format: "%.0f", data.current.temp)
            self.currentTemperature?.append("º")
            self.currentWeather = data.current.weather[0]
            self.currentWind = String(format: "%.1f", data.current.wind_speed)
            self.currentHumidity = data.current.humidity
            self.currentTemperatureFeels = String(format: "%.0f", data.current.feels_like)
            self.currentPressure = data.current.pressure
                    
            self.getCityName(lat: self.lat!, lon: self.lon!)
            
            for i in 0 ..< data.hourly.count {
                self.hourlyDate.append(Double(data.hourly[i].dt).getDateHourly(timeZone: timeZone!))
                self.hourlyTemperature.append(data.hourly[i].temp)
                self.hourlyWeather.append(contentsOf: data.hourly[i].weather)
                self.hourlyWind.append(data.hourly[i].wind_speed)
            }
            
            for i in 0 ..< data.daily.count {
                self.dailyDate.append(Double(data.daily[i].dt).getDateDaily(timeZone: timeZone!))
                self.dailyTemperature.append(data.daily[i].temp)
                self.dailyWeather.append(contentsOf: data.daily[i].weather)
                self.dailyWind.append(data.daily[i].wind_speed)
            }
        }
    }
    
    func getCoordinates() {
        DispatchQueue.main.async {
            let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate: CLLocationCoordinate2D()
            self.lat = coordinate.latitude
            self.lon = coordinate.longitude
        }
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
                    self.cityName = (city ?? "City not found") + ", " + country
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

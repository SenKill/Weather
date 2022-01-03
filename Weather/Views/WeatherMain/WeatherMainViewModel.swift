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
    
    @Published var alertMessage: String = ""
    @Published var alert: Bool = false
    
    private var locationManager = LocationManager()
    
    init() {
        /*
        let defaults = UserDefaults.standard
        // TODO: Save latest data to UserDefaults or CoreData
        
        if let current: CurrentWeather = defaults.object(forKey: "current") as? CurrentWeather {
            print(Date(timeIntervalSinceReferenceDate: TimeInterval(current.dt)))
        }*/
        
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
    
    func bindWeatherData(coordinate: CLLocationCoordinate2D) {
        var units: String {
            return UserDefaults.standard.string(forKey: "unit") ?? "metric"
        }
        
        var language: String {
            return Locale.current.languageCode ?? "en"
        }
        
        WeatherData().getData(latitude: String(coordinate.latitude), longtitude: String(coordinate.longitude), units: units, language: language) { data in
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
                    self.getCityName(placemark: placemark)
                }
            }
        }
    }
    
    private func getCityName(placemark: CLPlacemark) {
        guard let country = placemark.country else {
            print("ERROR: Wrong coordinates")
            return
        }
        let city = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.administrativeArea
        self.cityName = (city ?? "City not found") + ", " + country
        
        // self.saveData()
        self.isLoading = false
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
                if let coordinate = self.coordinate {
                    self.bindWeatherData(coordinate: coordinate)
                }
                print(error!.localizedDescription)
                self.alertMessage = "cannotFindCityError".localized()
                self.alert.toggle()
                return
            }
            if let placemark = placemarks?[0] {
                if let coordinates = placemark.location?.coordinate {
                    self.coordinate = coordinates
                    self.bindWeatherData(coordinate: coordinates)
                } else {
                    print("Error with converting city to coordinates")
                }
            }
        }
    }
    
    private func saveData() {
        let queue = DispatchQueue(label: "save.weatherdata")
        let defaults = UserDefaults.standard
        
        queue.async {
            defaults.setValue(self.timeZone, forKey: "timezone")
            defaults.setValue(self.cityName, forKey: "cityname")
            defaults.setValue(self.current, forKey: "current")
            defaults.setValue(self.daily, forKey: "daily")
            defaults.setValue(self.hourly, forKey: "hourly")
        }
    }
}

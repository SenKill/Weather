//
//  WeatherMainViewModel.swift
//  Weather
//
//  Created by Serik Musaev on 10/10/21.
//

import Foundation
import CoreLocation
import CoreData

final class WeatherMainViewModel: ObservableObject {
    @Published var timeZone: TimeZone!
    @Published var cityName: String = ""
    
    @Published var current: CurrentWeather!
    @Published var hourly: [HourlyWeather] = []
    @Published var daily: [DailyWeather] = []
    @Published var weatherDescription: WeatherDescription!
    
    @Published var coordinate: CLLocationCoordinate2D!
    @Published var isLoading: Bool = true
    
    @Published var alertMessage: String = ""
    @Published var alert: Bool = false
    
    private let locationManager = LocationManager()
    private let networkService = NetworkService()
    private let defaults = UserDefaults.standard
    
    init() {
        self.loadFromCoreData()
    }
    
    private func assignData(data: WeatherModel) {
        guard let timeZone = data.timezone,
              let current = data.current,
              let hourly = data.hourly?.array as? [HourlyWeather],
              let daily = data.daily?.array as? [DailyWeather],
              let description = data.current?.weather?.anyObject() as? WeatherDescription else {
            print("ERROR: Weather data is nil")
            return
        }
        
        self.timeZone = TimeZone(identifier: timeZone)
        self.current = current
        self.hourly = hourly
        self.daily = daily
        self.weatherDescription = description
        
        let coordinates = CLLocationCoordinate2D(latitude: Double(data.lat), longitude: Double(data.lon))
        self.coordinate = coordinates
        
        if let city = defaults.string(forKey: "city") {
            self.cityName = city
        }
        
        self.isLoading = false
    }
    
    private func loadFromCoreData() {
        self.isLoading = true
        let fetchRequest: NSFetchRequest<WeatherModel> = NSFetchRequest(entityName: "WeatherModel")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(WeatherModel.current.dt), ascending: true)]
        
        do {
            let data = try CoreDataStack.shared.managedContext.fetch(fetchRequest)
            
            guard let lastData = data.last else {
                self.loadData(withCity: nil)
                return
            }
            
            self.assignData(data: lastData)
            
            for object in data where object != data.last {
                CoreDataStack.shared.managedContext.delete(object)
            }
            CoreDataStack.shared.saveContext()
        } catch let error as NSError {
            print("Fetch error: \(error), \(error.userInfo)")
        }
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
    
    func bindWeatherData(coordinate: CLLocationCoordinate2D, completion: (() -> Void)? = nil) {
        var units: String {
            return UserDefaults.standard.string(forKey: "unit") ?? "metric"
        }
        networkService.makeRequest(.openWeatherOneCall(
            lat: String(coordinate.latitude), lon: String(coordinate.longitude), units: units,
            lang: Locale.current, token: Tokens.openWeatherMap), resultType: WeatherModel.self) { [weak self] result in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                completion?()
            }
            switch result {
            case .success(let data):
                self.assignData(data: data)
            case .failure(let error):
                print(error)
                self.isLoading = false
                self.alertMessage = error.description
                self.alert.toggle()
            }
        }
        self.coordinatesToCity(coordinates: coordinate)
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
        let location = (city ?? "City not found") + ", " + country
        self.cityName = location
        defaults.setValue(location, forKey: "city")
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
                self.alertMessage = "cannotFindCityError".localized
                self.alert.toggle()
                return
            }
            if let placemark = placemarks?[0] {
                if let coordinates = placemark.location?.coordinate {
                    self.coordinate = coordinates
                    self.bindWeatherData(coordinate: coordinates)
                }
            }
        }
    }
}

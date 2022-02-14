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
    
    private var locationManager = LocationManager()
    private lazy var coreDataStack = CoreDataStack(modelName: "Weather")
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(WeatherModel.current.dt), ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let data = try coreDataStack.managedContext.fetch(fetchRequest)
            guard let lastData = data.last else {
                print("Fetch error: last data cannot found")
                self.loadData(withCity: nil)
                return
            }
            
            self.assignData(data: lastData)
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
    
    func bindWeatherData(coordinate: CLLocationCoordinate2D) {
        var units: String {
            UserDefaults.standard.string(forKey: "unit") ?? "metric"
        }
        
        var language: String {
            Locale.current.languageCode ?? "en"
        }
        
        WeatherData.getData(
            latitude: String(coordinate.latitude),
            longtitude: String(coordinate.longitude),
            units: units,
            language: language,
            context: coreDataStack.managedContext) { result in
            switch result {
            case .success(let data):
                self.assignData(data: data)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.alertMessage = error.localizedDescription
                    self.alert.toggle()
                    self.isLoading = false
                }
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
}

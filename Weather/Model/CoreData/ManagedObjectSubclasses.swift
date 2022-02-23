//
//  ManagedObjectSubclasses.swift
//  Weather
//
//  Created by Serik Musaev on 1/20/22.
//

import CoreData
import Foundation


class WeatherModel: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case lat, lon, timezone, timezone_offset, current, hourly, daily
    }
    
    required convenience init(from decoder: Decoder) throws {
        let context = CoreDataStack.shared.managedContext
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.lat = try container.decode(Float.self, forKey: .lat)
        self.lon = try container.decode(Float.self, forKey: .lon)
        self.timezone = try container.decode(String.self, forKey: .timezone)
        self.timezone_offset = try container.decode(Int32.self, forKey: .timezone_offset)
        self.current = try container.decode(CurrentWeather.self, forKey: .current)
        let hourly = try container.decode([HourlyWeather].self, forKey: .hourly)
        hourly.forEach { self.addToHourly($0) }
        let daily = try container.decode([DailyWeather].self, forKey: .daily)
        daily.forEach { self.addToDaily($0) }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("CoreData Saving error: \(error), \(error.userInfo)")
        }
    }
}

class WeatherDescription: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case id, main, description, icon
    }
    
    required convenience init(from decoder: Decoder) throws {
        let context = CoreDataStack.shared.managedContext
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int32.self, forKey: .id)
        self.main = try container.decode(String.self, forKey: .main)
        self.weatherDescription = try container.decode(String.self, forKey: .description)
        self.icon = try container.decode(String.self, forKey: .icon)
    }
}

class Temperature: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case day, night, eve, morn, min, max
    }
    
    required convenience init(from decoder: Decoder) throws {
        let context = CoreDataStack.shared.managedContext
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.day = try container.decode(Float.self, forKey: .day)
        self.night = try container.decode(Float.self, forKey: .night)
        self.eve = try container.decode(Float.self, forKey: .eve)
        self.morn = try container.decode(Float.self, forKey: .morn)
        self.min = try container.decode(Float.self, forKey: .min)
        self.max = try container.decode(Float.self, forKey: .max)
    }
}

class TemperatureFeels: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case day, night, eve, morn
    }
    
    required convenience init(from decoder: Decoder) throws {
        let context = CoreDataStack.shared.managedContext
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.day = try container.decode(Float.self, forKey: .day)
        self.night = try container.decode(Float.self, forKey: .night)
        self.eve = try container.decode(Float.self, forKey: .eve)
        self.morn = try container.decode(Float.self, forKey: .morn)
    }
}

class HourlyWeather: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case dt, temp, feels_like, pressure, humidity, dew_point, uvi, clouds, visibility, wind_speed, wind_deg, wind_gust, weather, pop
    }
    
    required convenience init(from decoder: Decoder) throws {
        let context = CoreDataStack.shared.managedContext
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dt = try container.decode(Int32.self, forKey: .dt)
        self.temp = try container.decode(Float.self, forKey: .temp)
        self.feels_like = try container.decode(Float.self, forKey: .feels_like)
        self.pressure = try container.decode(Int32.self, forKey: .pressure)
        self.humidity = try container.decode(Int32.self, forKey: .humidity)
        self.dew_point = try container.decode(Float.self, forKey: .dew_point)
        self.uvi = try container.decode(Float.self, forKey: .uvi)
        self.clouds = try container.decode(Int32.self, forKey: .clouds)
        self.visibility = try container.decode(Int32.self, forKey: .visibility)
        self.wind_speed = try container.decode(Float.self, forKey: .wind_speed)
        self.wind_deg = try container.decode(Int32.self, forKey: .wind_deg)
        self.wind_gust = try container.decode(Float.self, forKey: .wind_gust)
        self.weather = try container.decode(Set<WeatherDescription>.self, forKey: .weather) as NSSet
        self.pop = try container.decode(Float.self, forKey: .pop)
    }
}

class DailyWeather: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case dt, sunrise, sunset, moonrise, moonset, moon_phase, temp, feels_like, pressure, humidity, dew_point, wind_speed, wind_deg, wind_gust, weather, clouds, pop, rain, uvi
    }
    
    required convenience init(from decoder: Decoder) throws {
        let context = CoreDataStack.shared.managedContext
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dt = try container.decode(Int32.self, forKey: .dt)
        self.sunrise = try container.decode(Int32.self, forKey: .sunrise)
        self.sunset = try container.decode(Int32.self, forKey: .sunset)
        self.moonrise = try container.decode(Int32.self, forKey: .moonrise)
        self.moonset = try container.decode(Int32.self, forKey: .moonset)
        self.moon_phase = try container.decode(Float.self, forKey: .moon_phase)
        self.temp = try container.decode(Temperature.self, forKey: .temp)
        self.feels_like = try container.decode(TemperatureFeels.self, forKey: .feels_like)
        self.pressure = try container.decode(Int32.self, forKey: .pressure)
        self.humidity = try container.decode(Int32.self, forKey: .humidity)
        self.dew_point = try container.decode(Float.self, forKey: .dew_point)
        self.wind_speed = try container.decode(Float.self, forKey: .wind_speed)
        self.wind_deg = try container.decode(Int32.self, forKey: .wind_deg)
        self.weather = try container.decode(Set<WeatherDescription>.self, forKey: .weather) as NSSet
        self.clouds = try container.decode(Int32.self, forKey: .clouds)
        self.pop = try container.decode(Float.self, forKey: .pop)
        if let rain = try? container.decode(Float.self, forKey: .rain) {
            self.rain = rain
        } else {
            self.rain = 0.0
        }
        self.uvi = try container.decode(Float.self, forKey: .uvi)
    }
}

class CurrentWeather: NSManagedObject, Decodable {
    enum CodingKeys: CodingKey {
        case dt, sunrise, sunset, temp, feels_like, pressure, humidity, dew_point, uvi, clouds, visibility, wind_speed, wind_deg, weather
    }
    
    required convenience init(from decoder: Decoder) throws {
        let context = CoreDataStack.shared.managedContext
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dt = try container.decode(Int32.self, forKey: .dt)
        self.sunrise = try container.decode(Int32.self, forKey: .sunrise)
        self.sunset = try container.decode(Int32.self, forKey: .sunset)
        self.temp = try container.decode(Float.self, forKey: .temp)
        self.feels_like = try container.decode(Float.self, forKey: .feels_like)
        self.pressure = try container.decode(Int32.self, forKey: .pressure)
        self.humidity = try container.decode(Int32.self, forKey: .humidity)
        self.dew_point = try container.decode(Float.self, forKey: .dew_point)
        self.uvi = try container.decode(Float.self, forKey: .uvi)
        self.clouds = try container.decode(Int32.self, forKey: .clouds)
        self.visibility = try container.decode(Int32.self, forKey: .visibility)
        self.wind_speed = try container.decode(Float.self, forKey: .wind_speed)
        self.wind_deg = try container.decode(Int32.self, forKey: .wind_deg)
        self.weather = try container.decode(Set<WeatherDescription>.self, forKey: .weather) as NSSet
    }
}

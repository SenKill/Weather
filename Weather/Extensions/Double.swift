//
//  Double.swift
//  Weather
//
//  Created by Serik Musaev on 11/19/21.
//

import Foundation

extension Double {
    func getDateCurrent(timeZone: TimeZone) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm, EEEE MMM dd"
        return dateFormatter.string(from: date)
    }
    
    func getDateHourly(timeZone: TimeZone) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func getDateDaily(timeZone: TimeZone) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }
}


//
//  NetworkError.swift
//  Weather
//
//  Created by Serik Musaev on 15.04.2023.
//

import Foundation

enum NetworkError: Error {
    case wrongUrl
    case noResponse
    case reponseError(statusCode: Int)
    case someError(message: String)
}

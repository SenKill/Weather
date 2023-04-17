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
    case decodingError
    case someError(message: String)
    
    var description: String {
        switch self {
        case .wrongUrl:
            return "ERR_WRONG_URL".localized
        case .noResponse:
            return "ERR_NO_RESPONSE".localized
        case .reponseError(let statusCode):
            return "ERR_STATUS_CODE".localized + " \(statusCode)"
        case .decodingError:
            return "ERR_DECODING".localized
        case .someError(let message):
            return message
        }
    }
}

//
//  Endpoint.swift
//  Weather
//
//  Created by Serik Musaev on 17.04.2023.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
}

struct Endpoint {
    let path: String
    let httpMethod: HTTPMethod
    let httpBody: Data?
    
    func getUrlRequest() -> URLRequest? {
        guard let url = URL(string: path) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = httpBody
        print(url.absoluteString)
        return urlRequest
    }
}

extension Endpoint {
    static func openWeatherOneCall(lat: String, lon: String, units: String, lang: String, token: Tokens) -> Endpoint {
        let endpoint = Endpoint(
            path: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,alerts&units=\(units)&lang=\(lang)&appid=\(token.rawValue)",
            httpMethod: .get, httpBody: nil)
        return endpoint
    }
    
    static func vkCountries(token: Tokens, lang: String) -> Endpoint {
        let endpoint = Endpoint(
            path: "https://api.vk.com/method/database.getCountries?access_token=\(token.rawValue)&need_all=1&count=1000&lang=\(lang)&v=5.131",
            httpMethod: .get, httpBody: nil)
        return endpoint
    }
    
    static func vkCities(token: Tokens, countryId: Int, query: String, count: Int, lang: String) -> Endpoint {
        let endpoint = Endpoint(
            path: "https://api.vk.com/method/database.getCities?access_token=\(token.rawValue)&country_id=\(countryId)\(query)&need_all=0&count=\(count)&lang=\(lang)&v=5.131".encodeUrl,
            httpMethod: .get, httpBody: nil)
        return endpoint
    }
}

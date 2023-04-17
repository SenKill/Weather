//
//  NetworkService.swift
//  Weather
//
//  Created by Serik Musaev on 17.04.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func makeRequest<T: Decodable>(_ endpoint: Endpoint, resultType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    let urlSession = URLSession.shared
    let decoder = JSONDecoder()
    
    func makeRequest<T: Decodable>(_ endpoint: Endpoint, resultType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        guard let url = endpoint.getUrlRequest() else { return }
        urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.someError(message: error.localizedDescription)))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.noResponse))
                    return
                }
                guard (200..<300).contains(response.statusCode) else {
                    completion(.failure(.reponseError(statusCode: response.statusCode)))
                    return
                }
                if let data = data {
                    completion(self.decodeData(data: data, decodingType: T.self))
                }
            }
        }
        .resume()
    }
}

// MARK: - Internal
private extension NetworkService {
    func decodeData<T: Decodable>(data: Data, decodingType: T.Type) -> Result<T, NetworkError>  {
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch let error as NSError {
            print("ERROR: \(error), userInfo: \(error.userInfo)")
            return .failure(.decodingError)
        }
    }
}

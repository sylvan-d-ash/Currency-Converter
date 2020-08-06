//
//  Webservice.swift
//  Currency Converter
//
//  Created by Sylvan Ash on 05/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

enum Endpoint {
    case currencies
    case live(source: String? = nil)

    var path: String {
        switch self {
            case .currencies: return "list"
            case .live: return "live"
        }
    }
}

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
}

class Webservice {
    private static let API_KEY = "b29c42cb194f63237334bcecb5d86f12"

    func makeRequest(endpoint: Endpoint, completion: @escaping(Result<Any, Error>) -> Void) {
        guard let url = buildQueryURL(endpoint: endpoint) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        URLSession.shared.dataTask(with: url) { dataOrNil, responseOrNil, errorOrNil in
            if let error = errorOrNil {
                completion(.failure(error))
                return
            }

            guard let data = dataOrNil else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchAllCurrencies(completion: @escaping(Result<Any, Error>) -> Void) {
        guard let url = buildQueryURL(endpoint: .currencies) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        URLSession.shared.dataTask(with: url) { dataOrNil, responseOrNil, errorOrNil in
            if let error = errorOrNil {
                completion(.failure(error))
                return
            }

            guard let data = dataOrNil else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchExchangeRates(source: String? = nil, completion: @escaping(Result<Any, Error>) -> Void) {
        guard let url = buildQueryURL(endpoint: .live(source: source)) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        URLSession.shared.dataTask(with: url) { dataOrNil, responseOrNil, errorOrNil in
            if let error = errorOrNil {
                completion(.failure(error))
                return
            }

            guard let data = dataOrNil else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private func buildQueryURL(endpoint: Endpoint) -> URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.currencylayer.com"
        components.path = "/\(endpoint.path)"

        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "access_key", value: Webservice.API_KEY))
        components.queryItems?.append(URLQueryItem(name: "format", value: "1"))

        if case let .live(sourceOrNil) = endpoint, let source = sourceOrNil {
            components.queryItems?.append(URLQueryItem(name: "source", value: source))
        }

        return components.url
    }
}

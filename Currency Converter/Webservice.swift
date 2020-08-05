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

class Webservice {
    private static let API_KEY = "b29c42cb194f63237334bcecb5d86f12"

    func fetchAllCurrencies(completion: @escaping(Result<Any, Error>) -> Void) {
        //
    }

    func fetchExchangeRates(completion: @escaping(Result<Any, Error>) -> Void) {
        //
    }

    private func buildQueryURL(endpoint: Endpoint, for location: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
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

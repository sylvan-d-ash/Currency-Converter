//
//  CacheService.swift
//  Currency Converter
//
//  Created by Sylvan Ash on 06/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

enum CacheError: Error {
    case noCacheError
    case expiredCacheError
    case cacheParsingError
}

protocol CacheServiceProtocol: AnyObject {
    func fetchCurrencies(completion: (Result<[Currency], Error>) -> Void)
    func saveCurrencies(_ currencies: [Currency])
}

class CacheService: CacheServiceProtocol {
    private let defaults = UserDefaults.standard

    func fetchCurrencies(completion: (Result<[Currency], Error>) -> Void) {
        guard let time = defaults.object(forKey: Constants.Keys.time) as? Date else {
            completion(.failure(CacheError.noCacheError))
            return
        }
        guard time.advanced(by: TimeInterval(Constants.cacheDuration)) > Date() else {
            completion(.failure(CacheError.expiredCacheError))
            return
        }
        guard let data = defaults.data(forKey: Constants.Keys.currencies) else {
            completion(.failure(CacheError.noCacheError))
            return
        }

        do {
            let currencies = try JSONDecoder().decode([Currency].self, from: data)
            completion(.success(currencies))
        } catch {
            print(error.localizedDescription)
            completion(.failure(CacheError.cacheParsingError))
        }
    }

    func saveCurrencies(_ currencies: [Currency]) {
        do {
            let data = try JSONEncoder().encode(currencies)
            defaults.set(data, forKey: Constants.Keys.currencies)
            defaults.set(Date(), forKey: Constants.Keys.time)
        } catch {
            print(error.localizedDescription)
        }
    }
}

private enum Constants {
    static let cacheDuration = 30 * 60 // 30min

    enum Keys {
        static let time = "CacheTime"
        static let currencies = "Currencies"
    }
}

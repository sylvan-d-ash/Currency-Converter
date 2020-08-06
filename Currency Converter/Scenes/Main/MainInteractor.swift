//
//  MainInteractor.swift
//  Currency Converter
//
//  Created by Sylvan Ash on 06/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

enum ParseError: Error {
    case parseCurrenciesError
    case parseExchangeRatesError
}

class MainInteractor {
    weak var presenter: MainPresenter!
    private let webservice: Webservice
    private var currencies = [Currency]()

    init(presenter: MainPresenter, webservice: Webservice = Webservice()) {
        self.presenter = presenter
        self.webservice = webservice
    }

    func fetchCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void) {
        webservice.makeRequest(endpoint: .currencies) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let json):
                guard let currencies = self?.parseCurrencies(json: json) else {
                    completion(.failure(ParseError.parseCurrenciesError))
                    return
                }

                self?.fetchExchangeRates(currencies: currencies, completion: completion)
            }
        }
    }

    func fetchExchangeRates(currencies: [Currency], completion: @escaping (Result<[Currency], Error>) -> Void) {
        webservice.makeRequest(endpoint: .live(source: nil)) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let json):
                self?.parseExchangeRates(json: json, currencies: currencies, completion: completion)
            }
        }
    }
}

private extension MainInteractor {
    func parseCurrencies(json: Any) -> [Currency]? {
        guard let jsonDict = json as? [String: Any], let currenciesDict = jsonDict[Keys.currencies] as? [String: String] else {
            return nil
        }

        var currencies = [Currency]()
        for (code, name) in currenciesDict {
            let currency = Currency(code: code, name: name)
            currencies.append(currency)
        }

        currencies.sort { (first, second) -> Bool in
            first.name < second.name
        }

        return currencies
    }

    func parseExchangeRates(json: Any, currencies: [Currency], completion: @escaping (Result<[Currency], Error>) -> Void) {
        guard let jsonDict = json as? [String: Any], let rates = jsonDict[Keys.rates] as? [String: Double] else {
            completion(.failure(ParseError.parseExchangeRatesError))
            return
        }

        var currencies = currencies
        for i in 0..<currencies.count {
            var currency = currencies[i]
            let key = "\(Keys.usd)\(currency.code)"
            guard let rate = rates[key] else { continue }

            currency.rate = rate
            currencies[i] = currency
        }

        completion(.success(currencies))
    }
}

private enum Keys {
    static let currencies = "currencies"
    static let rates = "quotes"
    static let usd = "USD"
    static let defaultSource = "USDUSD"
}

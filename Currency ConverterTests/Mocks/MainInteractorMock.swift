//
//  MainInteractorMock.swift
//  Currency ConverterTests
//
//  Created by Sylvan Ash on 06/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation
@testable import Currency_Converter

class MainInteractorMock: MainInteractorProtocol {
    private(set) var didCallFetchCurrencies = false
    private(set) var didCallFetchExchangeRates = false
    private(set) var currencies: [Currency]?
    var error: NetworkError?

    func fetchCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if let error = self.error {
                completion(.failure(error))
            } else {
                // TODO: implement
                completion(.success([]))
            }
        }
    }

    func fetchExchangeRates(currencies: [Currency], completion: @escaping (Result<[Currency], Error>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if let error = self.error {
                completion(.failure(error))
            } else {
                // TODO: implement
                completion(.success([]))
            }
        }
    }
}

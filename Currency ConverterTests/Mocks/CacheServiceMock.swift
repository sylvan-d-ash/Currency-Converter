//
//  CacheServiceMock.swift
//  Currency ConverterTests
//
//  Created by Sylvan Ash on 06/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation
@testable import Currency_Converter

class CacheServiceMock: CacheServiceProtocol {
    private(set) var didCallFetchCurrencies = false
    private(set) var didCallSaveCurrencies = false
    private(set) var currencies: [Currency]?
    var error: CacheError?

    func fetchCurrencies(completion: (Result<[Currency], Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            // TODO: implement mock data
            completion(.success([]))
        }
    }

    func saveCurrencies(_ currencies: [Currency]) {
        <#code#>
    }
}

//
//  WebserviceMock.swift
//  Currency ConverterTests
//
//  Created by Sylvan Ash on 06/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation
@testable import Currency_Converter

class WebserviceMock: WebserviceProtocol {
    private(set) var didCallFetchResource = false
    private(set) var endpoint: Endpoint?
    var error: NetworkError?

    func fetchResource(endpoint: Endpoint, completion: @escaping (Result<Any, Error>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if let error = self.error {
                completion(.failure(error))
            } else {
                // TODO: return mock data
                completion(.success(true))
            }
        }
    }
}

//
//  Currency.swift
//  Currency Converter
//
//  Created by Sylvan Ash on 05/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

struct Currency: Codable {
    let code: String
    let name: String
    var price: Decimal = 0
}

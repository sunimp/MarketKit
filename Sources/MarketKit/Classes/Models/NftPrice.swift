//
//  NftPrice.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public struct NftPrice {
    public let token: Token
    public let value: Decimal

    public init(token: Token, value: Decimal) {
        self.token = token
        self.value = value
    }
}

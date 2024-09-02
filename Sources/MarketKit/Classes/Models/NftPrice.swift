//
//  NftPrice.swift
//
//  Created by Sun on 2022/5/24.
//

import Foundation

public struct NftPrice {
    // MARK: Properties

    public let token: Token
    public let value: Decimal

    // MARK: Lifecycle

    public init(token: Token, value: Decimal) {
        self.token = token
        self.value = value
    }
}

//
//  TokenHolders.swift
//  MarketKit
//
//  Created by Sun on 2023/3/6.
//

import Foundation

import ObjectMapper

public struct TokenHolders: ImmutableMappable {
    // MARK: Nested Types

    public struct Holder: ImmutableMappable {
        // MARK: Properties

        public let address: String
        public let percentage: Decimal
        public let balance: Decimal

        // MARK: Lifecycle

        public init(map: Map) throws {
            address = try map.value("address")
            percentage = try map.value("percentage", using: Transform.stringToDecimalTransform)
            balance = try map.value("balance", using: Transform.stringToDecimalTransform)
        }
    }

    // MARK: Properties

    public let count: Decimal
    public let holdersURL: String?
    public let topHolders: [Holder]

    // MARK: Lifecycle

    public init(map: Map) throws {
        count = try map.value("count", using: Transform.stringToDecimalTransform)
        holdersURL = try? map.value("holders_url")
        topHolders = try map.value("top_holders")
    }
}

//
//  CategoryMarketPoint.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import ObjectMapper

// MARK: - CategoryMarketPoint

public class CategoryMarketPoint: ImmutableMappable {
    public let timestamp: TimeInterval
    public let marketCap: Decimal

    public required init(map: Map) throws {
        timestamp = try map.value("timestamp")
        marketCap = try map.value("market_cap", using: Transform.stringToDecimalTransform)
    }
}

// MARK: CustomStringConvertible

extension CategoryMarketPoint: CustomStringConvertible {
    public var description: String {
        "CategoryMarketPoint [timestamp: \(timestamp); marketCap: \(marketCap)]"
    }
}

//
//  CategoryMarketPoint.swift
//
//  Created by Sun on 2022/5/19.
//

import Foundation

import ObjectMapper

// MARK: - CategoryMarketPoint

public class CategoryMarketPoint: ImmutableMappable {
    // MARK: Properties

    public let timestamp: TimeInterval
    public let marketCap: Decimal

    // MARK: Lifecycle

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

//
//  CoinCategory.swift
//  MarketKit
//
//  Created by Sun on 2021/8/26.
//

import Foundation

import ObjectMapper

// MARK: - CoinCategory

public class CoinCategory: ImmutableMappable {
    // MARK: Properties

    public let uid: String
    public let name: String
    public let descriptions: [String: String]
    public let marketCap: Decimal?
    public let diff24H: Decimal?
    public let diff1W: Decimal?
    public let diff1M: Decimal?

    // MARK: Lifecycle

    public required init(map: Map) throws {
        uid = try map.value("uid")
        name = try map.value("name")
        descriptions = try map.value("description")

        marketCap = try? map.value("market_cap", using: Transform.stringToDecimalTransform)
        diff24H = try? map.value("change_24h", using: Transform.stringToDecimalTransform)
        diff1W = try? map.value("change_1w", using: Transform.stringToDecimalTransform)
        diff1M = try? map.value("change_1m", using: Transform.stringToDecimalTransform)
    }
}

extension CoinCategory {
    public func diff(timePeriod: SWTimePeriod) -> Decimal? {
        switch timePeriod {
        case .day1: diff24H
        case .week1: diff1W
        case .month1: diff1M
        default: diff24H
        }
    }
}

// MARK: CustomStringConvertible

extension CoinCategory: CustomStringConvertible {
    public var description: String {
        "CoinCategory [uid: \(uid); name: \(name); descriptionCount: \(descriptions.count)]"
    }
}

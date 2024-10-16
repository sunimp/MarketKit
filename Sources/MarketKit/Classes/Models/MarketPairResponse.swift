//
//  MarketPairResponse.swift
//  MarketKit
//
//  Created by Sun on 2021/10/7.
//

import Foundation

import ObjectMapper

public struct MarketPairResponse: ImmutableMappable {
    // MARK: Properties

    public let base: String
    public let baseCoinUid: String?
    public let target: String
    public let targetCoinUid: String?
    public let marketName: String
    public let marketImageURL: String?
    public let rank: Int
    public let volume: Decimal?
    public let price: Decimal?
    public let tradeURL: String?

    // MARK: Computed Properties

    public var uid: String {
        "\(base) \(target) \(marketName)"
    }

    // MARK: Lifecycle

    public init(map: Map) throws {
        base = try map.value("base")
        baseCoinUid = try? map.value("base_uid")
        target = try map.value("target")
        targetCoinUid = try? map.value("target_uid")
        marketName = try map.value("market_name")
        marketImageURL = try? map.value("market_logo")
        rank = try map.value("rank")
        volume = try? map.value("volume", using: Transform.stringToDecimalTransform)
        price = try? map.value("price", using: Transform.stringToDecimalTransform)
        tradeURL = try? map.value("trade_url")
    }
}

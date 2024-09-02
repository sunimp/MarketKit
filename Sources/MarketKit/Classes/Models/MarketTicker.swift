//
//  MarketTicker.swift
//
//  Created by Sun on 2021/10/7.
//

import Foundation

import ObjectMapper

public struct MarketTicker: ImmutableMappable {
    // MARK: Properties

    public let base: String
    public let target: String
    public let marketName: String
    public let marketImageURL: String?
    public let volume: Decimal
    public let fiatVolume: Decimal
    public let tradeURL: String?
    public let verified: Bool

    // MARK: Lifecycle

    public init(map: Map) throws {
        base = try map.value("base")
        target = try map.value("target")
        marketName = try map.value("market_name")
        marketImageURL = try? map.value("market_logo")
        volume = try map.value("volume", using: Transform.stringToDecimalTransform)
        fiatVolume = try map.value("volume_in_currency", using: Transform.stringToDecimalTransform)
        tradeURL = try? map.value("trade_url")
        verified = try map.value("whitelisted")
    }
}

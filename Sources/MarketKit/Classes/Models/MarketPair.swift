//
//  MarketPair.swift
//
//  Created by Sun on 2021/10/7.
//

import Foundation

import ObjectMapper

public struct MarketPair {
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
    public let baseCoin: Coin?
    public let targetCoin: Coin?

    // MARK: Computed Properties

    public var uid: String {
        "\(base) \(target) \(marketName)"
    }
}

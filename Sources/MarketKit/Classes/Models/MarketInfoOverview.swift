//
//  MarketInfoOverview.swift
//
//  Created by Sun on 2021/10/1.
//

import Foundation

// MARK: - MarketInfoOverview

public struct MarketInfoOverview {
    public let fullCoin: FullCoin
    public let marketCap: Decimal?
    public let marketCapRank: Int?
    public let totalSupply: Decimal?
    public let circulatingSupply: Decimal?
    public let volume24h: Decimal?
    public let dilutedMarketCap: Decimal?
    public let performance: [PerformanceRow]
    public let genesisDate: Date?
    public let categories: [CoinCategory]
    public let description: String
    public let links: [LinkType: String]
}

// MARK: - LinkType

public enum LinkType: String {
    case guide
    case website
    case whitepaper
    case twitter
    case telegram
    case reddit
    case github
}

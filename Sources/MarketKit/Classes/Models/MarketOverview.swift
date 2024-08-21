//
//  MarketOverview.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public struct MarketOverview {
    public let globalMarketPoints: [GlobalMarketPoint]
    public let coinCategories: [CoinCategory]
    public let topPairs: [MarketPair]
    public let topPlatforms: [TopPlatform]
    public let collections: [WWTimePeriod: [NftTopCollection]]
}

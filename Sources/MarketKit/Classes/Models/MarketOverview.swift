//
//  MarketOverview.swift
//
//  Created by Sun on 2022/5/24.
//

import Foundation

public struct MarketOverview {
    public let globalMarketPoints: [GlobalMarketPoint]
    public let coinCategories: [CoinCategory]
    public let topPairs: [MarketPair]
    public let topPlatforms: [TopPlatform]
    public let collections: [WWTimePeriod: [NFTTopCollection]]
}

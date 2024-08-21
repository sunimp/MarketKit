//
//  MarketOverviewManager.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

class MarketOverviewManager {
    private let nftManager: NftManager
    private let provider: WWProvider

    init(nftManager: NftManager, provider: WWProvider) {
        self.nftManager = nftManager
        self.provider = provider
    }
}

extension MarketOverviewManager {
    func marketOverview(currencyCode: String) async throws -> MarketOverview {
        let response = try await provider.marketOverview(currencyCode: currencyCode)

        return MarketOverview(
            globalMarketPoints: response.globalMarketPoints,
            coinCategories: response.coinCategories,
            topPairs: response.topPairs,
            topPlatforms: response.topPlatforms.map(\.topPlatform),
            collections: [
                .day1: nftManager.topCollections(responses: response.collections1d),
                .week1: nftManager.topCollections(responses: response.collections1w),
                .month1: nftManager.topCollections(responses: response.collections1m),
            ]
        )
    }
}

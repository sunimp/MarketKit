//
//  MarketOverviewManager.swift
//
//  Created by Sun on 2022/5/24.
//

import Foundation

// MARK: - MarketOverviewManager

class MarketOverviewManager {
    // MARK: Properties

    private let nftManager: NFTManager
    private let provider: WWProvider

    // MARK: Lifecycle

    init(nftManager: NFTManager, provider: WWProvider) {
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

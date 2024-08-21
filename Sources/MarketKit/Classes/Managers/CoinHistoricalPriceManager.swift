//
//  CoinHistoricalPriceManager.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

class CoinHistoricalPriceManager {
    private let storage: CoinHistoricalPriceStorage
    private let provider: WWProvider

    init(storage: CoinHistoricalPriceStorage, provider: WWProvider) {
        self.storage = storage
        self.provider = provider
    }
}

extension CoinHistoricalPriceManager {
    func cachedCoinHistoricalPriceValue(coinUid: String, currencyCode: String, timestamp: TimeInterval) -> Decimal? {
        try? storage.coinHistoricalPrice(coinUid: coinUid, currencyCode: currencyCode, timestamp: timestamp)?.value
    }

    func coinHistoricalPriceValue(coinUid: String, currencyCode: String, timestamp: TimeInterval) async throws -> Decimal {
        let response = try await provider.historicalCoinPrice(coinUid: coinUid, currencyCode: currencyCode, timestamp: timestamp)

        guard abs(Int(timestamp) - response.timestamp) < 24 * 60 * 60 else { // 1 day
            throw ResponseError.returnedTimestampIsTooInaccurate
        }

        try? storage.save(coinHistoricalPrice: CoinHistoricalPrice(coinUid: coinUid, currencyCode: currencyCode, value: response.price, timestamp: timestamp))

        return response.price
    }
}

extension CoinHistoricalPriceManager {
    enum ResponseError: Error {
        case returnedTimestampIsTooInaccurate
    }
}

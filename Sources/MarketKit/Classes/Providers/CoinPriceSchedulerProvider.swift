//
//  CoinPriceSchedulerProvider.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - ICoinPriceCoinUidDataSource

protocol ICoinPriceCoinUidDataSource: AnyObject {
    func allCoinUids(currencyCode: String) -> [String]
    func combinedCoinUids(currencyCode: String) -> ([String], [String])
}

// MARK: - CoinPriceSchedulerProvider

class CoinPriceSchedulerProvider {
    private let currencyCode: String
    private let manager: CoinPriceManager
    private let provider: WWProvider

    weak var dataSource: ICoinPriceCoinUidDataSource?

    init(manager: CoinPriceManager, provider: WWProvider, currencyCode: String) {
        self.manager = manager
        self.provider = provider
        self.currencyCode = currencyCode
    }

    private var allCoinUids: [String] {
        dataSource?.allCoinUids(currencyCode: currencyCode) ?? []
    }

    private func handle(updatedCoinPrices: [CoinPrice]) {
        manager.handleUpdated(coinPrices: updatedCoinPrices, currencyCode: currencyCode)
    }
}

// MARK: ISchedulerProvider

extension CoinPriceSchedulerProvider: ISchedulerProvider {
    var id: String {
        "CoinPriceProvider"
    }

    var lastSyncTimestamp: TimeInterval? {
        manager.lastSyncTimestamp(coinUids: allCoinUids, currencyCode: currencyCode)
    }

    var expirationInterval: TimeInterval {
        CoinPrice.expirationInterval
    }

    func sync() async throws {
        guard let (coinUids, walletCoinUids) = dataSource?.combinedCoinUids(currencyCode: currencyCode), !coinUids.isEmpty else {
            return
        }

        let coinPrices = try await provider.coinPrices(
            coinUids: coinUids,
            walletCoinUids: walletCoinUids,
            currencyCode: currencyCode
        )
        handle(updatedCoinPrices: coinPrices)
    }

    func notifyExpired() {
        manager.notifyExpired(coinUids: allCoinUids, currencyCode: currencyCode)
    }
}

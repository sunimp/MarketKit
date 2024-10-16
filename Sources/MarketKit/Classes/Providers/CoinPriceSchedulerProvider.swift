//
//  CoinPriceSchedulerProvider.swift
//  MarketKit
//
//  Created by Sun on 2021/9/22.
//

import Foundation

// MARK: - ICoinPriceCoinUidDataSource

protocol ICoinPriceCoinUidDataSource: AnyObject {
    func allCoinUids(currencyCode: String) -> [String]
    func combinedCoinUids(currencyCode: String) -> ([String], [String])
}

// MARK: - CoinPriceSchedulerProvider

class CoinPriceSchedulerProvider {
    // MARK: Properties

    weak var dataSource: ICoinPriceCoinUidDataSource?

    private let currencyCode: String
    private let manager: CoinPriceManager
    private let provider: SWProvider

    // MARK: Computed Properties

    private var allCoinUids: [String] {
        dataSource?.allCoinUids(currencyCode: currencyCode) ?? []
    }

    // MARK: Lifecycle

    init(manager: CoinPriceManager, provider: SWProvider, currencyCode: String) {
        self.manager = manager
        self.provider = provider
        self.currencyCode = currencyCode
    }

    // MARK: Functions

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
        guard
            let (coinUids, walletCoinUids) = dataSource?.combinedCoinUids(currencyCode: currencyCode),
            !coinUids.isEmpty
        else {
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

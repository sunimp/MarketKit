//
//  CoinPriceManager.swift
//  MarketKit
//
//  Created by Sun on 2021/9/22.
//

import Foundation

// MARK: - ICoinPriceManagerDelegate

protocol ICoinPriceManagerDelegate: AnyObject {
    func didUpdate(coinPriceMap: [String: CoinPrice], currencyCode: String)
}

// MARK: - CoinPriceManager

class CoinPriceManager {
    // MARK: Properties

    weak var delegate: ICoinPriceManagerDelegate?

    private let storage: CoinPriceStorage

    // MARK: Lifecycle

    init(storage: CoinPriceStorage) {
        self.storage = storage
    }

    // MARK: Functions

    private func notify(coinPrices: [CoinPrice], currencyCode: String) {
        var coinPriceMap = [String: CoinPrice]()

        for coinPrice in coinPrices {
            coinPriceMap[coinPrice.coinUid] = coinPrice
        }

        delegate?.didUpdate(coinPriceMap: coinPriceMap, currencyCode: currencyCode)
    }
}

extension CoinPriceManager {
    func lastSyncTimestamp(coinUids: [String], currencyCode: String) -> TimeInterval? {
        do {
            let coinPrices = try storage.coinPricesSortedByTimestamp(coinUids: coinUids, currencyCode: currencyCode)

            // not all records for coin codes are stored in database - force sync required
            guard coinPrices.count == coinUids.count else {
                return nil
            }

            // return date of the most expired stored record
            return coinPrices.first?.timestamp
        } catch {
            return nil
        }
    }

    func coinPrice(coinUid: String, currencyCode: String) -> CoinPrice? {
        try? storage.coinPrice(coinUid: coinUid, currencyCode: currencyCode)
    }

    func coinPriceMap(coinUids: [String], currencyCode: String) -> [String: CoinPrice] {
        var map = [String: CoinPrice]()

        do {
            for coinPrice in try storage.coinPrices(coinUids: coinUids, currencyCode: currencyCode) {
                map[coinPrice.coinUid] = coinPrice
            }
        } catch { }

        return map
    }

    func handleUpdated(coinPrices: [CoinPrice], currencyCode: String) {
        do {
            try storage.save(coinPrices: coinPrices)
            notify(coinPrices: coinPrices, currencyCode: currencyCode)
        } catch {
            // todo
        }
    }

    func notifyExpired(coinUids: [String], currencyCode: String) {
        do {
            let coinPrices = try storage.coinPrices(coinUids: coinUids, currencyCode: currencyCode)
            notify(coinPrices: coinPrices, currencyCode: currencyCode)
        } catch {
            // todo
        }
    }
}

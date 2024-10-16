//
//  GlobalMarketInfoManager.swift
//  MarketKit
//
//  Created by Sun on 2021/10/13.
//

import Foundation

// MARK: - GlobalMarketInfoManager

class GlobalMarketInfoManager {
    // MARK: Properties

    private let expirationInterval: TimeInterval = 600 // 6 mins

    private let provider: SWProvider
    private let storage: GlobalMarketInfoStorage

    // MARK: Lifecycle

    init(provider: SWProvider, storage: GlobalMarketInfoStorage) {
        self.provider = provider
        self.storage = storage
    }
}

extension GlobalMarketInfoManager {
    func globalMarketPoints(currencyCode: String, timePeriod: SWTimePeriod) async throws -> [GlobalMarketPoint] {
        let currentTimestamp = Date().timeIntervalSince1970

        if
            let storedInfo = try? storage.globalMarketInfo(currencyCode: currencyCode, timePeriod: timePeriod),
            currentTimestamp - storedInfo.timestamp < expirationInterval {
            return storedInfo.points
        }

        let points = try await provider.globalMarketPoints(currencyCode: currencyCode, timePeriod: timePeriod)

        let info = GlobalMarketInfo(currencyCode: currencyCode, timePeriod: timePeriod, points: points)
        try? storage.save(globalMarketInfo: info)

        return points
    }
}

//
//  GlobalMarketInfoManager.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - GlobalMarketInfoManager

class GlobalMarketInfoManager {
    private let expirationInterval: TimeInterval = 600 // 6 mins

    private let provider: WWProvider
    private let storage: GlobalMarketInfoStorage

    init(provider: WWProvider, storage: GlobalMarketInfoStorage) {
        self.provider = provider
        self.storage = storage
    }
}

extension GlobalMarketInfoManager {
    func globalMarketPoints(currencyCode: String, timePeriod: WWTimePeriod) async throws -> [GlobalMarketPoint] {
        let currentTimestamp = Date().timeIntervalSince1970

        if
            let storedInfo = try? storage.globalMarketInfo(currencyCode: currencyCode, timePeriod: timePeriod),
            currentTimestamp - storedInfo.timestamp < expirationInterval
        {
            return storedInfo.points
        }

        let points = try await provider.globalMarketPoints(currencyCode: currencyCode, timePeriod: timePeriod)

        let info = GlobalMarketInfo(currencyCode: currencyCode, timePeriod: timePeriod, points: points)
        try? storage.save(globalMarketInfo: info)

        return points
    }
}

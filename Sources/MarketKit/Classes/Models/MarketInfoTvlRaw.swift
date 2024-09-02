//
//  MarketInfoTvlRaw.swift
//
//  Created by Sun on 2021/11/4.
//

import Foundation

import ObjectMapper

class MarketInfoTvlRaw: ImmutableMappable {
    // MARK: Properties

    let timestamp: TimeInterval
    let tvl: Decimal?

    // MARK: Computed Properties

    var marketInfoTvl: ChartPoint? {
        guard let tvl else {
            return nil
        }

        return ChartPoint(timestamp: timestamp, value: tvl)
    }

    // MARK: Lifecycle

    required init(map: Map) throws {
        let timestampInt: Int = try map.value("date")
        timestamp = TimeInterval(timestampInt)
        tvl = try? map.value("tvl", using: Transform.stringToDecimalTransform)
    }
}

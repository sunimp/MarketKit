//
//  TopMoversRaw.swift
//  MarketKit
//
//  Created by Sun on 2022/5/24.
//

import Foundation

import ObjectMapper

struct TopMoversRaw: ImmutableMappable {
    // MARK: Properties

    let gainers100: [MarketInfoRaw]
    let gainers200: [MarketInfoRaw]
    let gainers300: [MarketInfoRaw]
    let losers100: [MarketInfoRaw]
    let losers200: [MarketInfoRaw]
    let losers300: [MarketInfoRaw]

    // MARK: Lifecycle

    public init(map: Map) throws {
        gainers100 = try map.value("gainers_100")
        gainers200 = try map.value("gainers_200")
        gainers300 = try map.value("gainers_300")
        losers100 = try map.value("losers_100")
        losers200 = try map.value("losers_200")
        losers300 = try map.value("losers_300")
    }
}

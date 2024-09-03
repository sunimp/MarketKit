//
//  MarketOverviewResponse.swift
//
//  Created by Sun on 2022/5/24.
//

import Foundation

import ObjectMapper

struct MarketOverviewResponse: ImmutableMappable {
    // MARK: Properties

    let globalMarketPoints: [GlobalMarketPoint]
    let coinCategories: [CoinCategory]
    let topPairs: [MarketPair]
    let topPlatforms: [TopPlatformResponse]
    let collections1d: [NFTTopCollectionResponse]
    let collections1w: [NFTTopCollectionResponse]
    let collections1m: [NFTTopCollectionResponse]

    // MARK: Lifecycle

    init(map: Map) throws {
        globalMarketPoints = try map.value("global")
        coinCategories = try map.value("sectors")
        topPairs = try map.value("pairs")
        topPlatforms = try map.value("platforms")
        collections1d = (try? map.value("nft.one_day")) ?? []
        collections1w = (try? map.value("nft.seven_day")) ?? []
        collections1m = (try? map.value("nft.thirty_day")) ?? []
    }
}

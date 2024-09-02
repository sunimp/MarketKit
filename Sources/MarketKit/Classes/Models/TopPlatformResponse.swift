//
//  TopPlatformResponse.swift
//
//  Created by Sun on 2022/5/4.
//

import Foundation

import ObjectMapper

// MARK: - TopPlatformResponse

struct TopPlatformResponse: ImmutableMappable {
    // MARK: Properties

    let uid: String
    let name: String
    let rank: Int?
    let protocolsCount: Int?
    let marketCap: Decimal?
    let stats: StatsResponse

    // MARK: Computed Properties

    var topPlatform: TopPlatform {
        var ranks = [WWTimePeriod: Int]()
        ranks[.week1] = stats.rank1w
        ranks[.month1] = stats.rank1m
        ranks[.month3] = stats.rank3m

        var changes = [WWTimePeriod: Decimal]()
        changes[.week1] = stats.change1w
        changes[.month1] = stats.change1m
        changes[.month3] = stats.change3m

        return TopPlatform(
            blockchain: Blockchain(type: BlockchainType(uid: uid), name: name, explorerURL: nil),
            rank: rank,
            protocolsCount: protocolsCount,
            marketCap: marketCap,
            ranks: ranks,
            changes: changes
        )
    }

    // MARK: Lifecycle

    init(map: Map) throws {
        uid = try map.value("uid")
        name = try map.value("name")
        rank = try? map.value("rank")
        protocolsCount = try? map.value("protocols")
        marketCap = try? map.value("market_cap", using: Transform.stringToDecimalTransform)
        stats = try map.value("stats")
    }
}

// MARK: TopPlatformResponse.StatsResponse

extension TopPlatformResponse {
    struct StatsResponse: ImmutableMappable {
        // MARK: Properties

        let rank1w: Int?
        let rank1m: Int?
        let rank3m: Int?
        let change1w: Decimal?
        let change1m: Decimal?
        let change3m: Decimal?

        // MARK: Lifecycle

        init(map: Map) throws {
            rank1w = try? map.value("rank_1w", using: Transform.stringToIntTransform)
            rank1m = try? map.value("rank_1m", using: Transform.stringToIntTransform)
            rank3m = try? map.value("rank_3m", using: Transform.stringToIntTransform)

            change1w = try? map.value("change_1w", using: Transform.stringToDecimalTransform)
            change1m = try? map.value("change_1m", using: Transform.stringToDecimalTransform)
            change3m = try? map.value("change_3m", using: Transform.stringToDecimalTransform)
        }
    }
}

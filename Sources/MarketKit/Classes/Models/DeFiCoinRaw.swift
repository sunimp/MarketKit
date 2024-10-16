//
//  DeFiCoinRaw.swift
//  MarketKit
//
//  Created by Sun on 2021/11/8.
//

import Foundation

import ObjectMapper

class DeFiCoinRaw: ImmutableMappable {
    // MARK: Properties

    let uid: String
    let coinUid: String?
    let name: String
    let logo: String
    let tvl: Decimal
    let tvlRank: Int
    let tvlChange1d: Decimal?
    let tvlChange1w: Decimal?
    let tvlChange2w: Decimal?
    let tvlChange1m: Decimal?
    let tvlChange3m: Decimal?
    let tvlChange6m: Decimal?
    let tvlChange1y: Decimal?
    let chains: [String]
    let chainTvls: [String: Decimal]

    // MARK: Lifecycle

    required init(map: Map) throws {
        uid = try map.value("uid")
        coinUid = try? map.value("coin_uid")
        name = try map.value("name")
        logo = try map.value("logo")
        tvl = try map.value("tvl", using: Transform.stringToDecimalTransform)
        tvlRank = try map.value("tvl_rank")
        tvlChange1d = try? map.value("tvl_change_1d", using: Transform.stringToDecimalTransform)
        tvlChange1w = try? map.value("tvl_change_1w", using: Transform.stringToDecimalTransform)
        tvlChange2w = try? map.value("tvl_change_2w", using: Transform.stringToDecimalTransform)
        tvlChange1m = try? map.value("tvl_change_1m", using: Transform.stringToDecimalTransform)
        tvlChange3m = try? map.value("tvl_change_3m", using: Transform.stringToDecimalTransform)
        tvlChange6m = try? map.value("tvl_change_6m", using: Transform.stringToDecimalTransform)
        tvlChange1y = try? map.value("tvl_change_1y", using: Transform.stringToDecimalTransform)
        chains = try map.value("chains")
        chainTvls = (try? map.value("chain_tvls", using: Transform.stringToDecimalTransform)) ?? [:]
    }

    // MARK: Functions

    func defiCoin(uid: String, fullCoin: FullCoin?) -> DeFiCoin {
        let type: DeFiCoin.DeFiCoinType =
            if let fullCoin {
                .fullCoin(fullCoin: fullCoin)
            } else {
                .defiCoin(name: name, logo: logo)
            }

        return DeFiCoin(
            uid: uid,
            type: type,
            tvl: tvl,
            tvlRank: tvlRank,
            tvlChange1d: tvlChange1d,
            tvlChange1w: tvlChange1w,
            tvlChange2w: tvlChange2w,
            tvlChange1m: tvlChange1m,
            tvlChange3m: tvlChange3m,
            tvlChange6m: tvlChange6m,
            tvlChange1y: tvlChange1y,
            chains: chains,
            chainTvls: chainTvls
        )
    }
}

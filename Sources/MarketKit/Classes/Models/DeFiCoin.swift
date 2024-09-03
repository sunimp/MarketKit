//
//  DeFiCoin.swift
//
//  Created by Sun on 2021/11/8.
//

import Foundation

public struct DeFiCoin {
    // MARK: Nested Types

    public enum DeFiCoinType {
        case fullCoin(fullCoin: FullCoin)
        case defiCoin(name: String, logo: String)
    }

    // MARK: Properties

    public let uid: String
    public let type: DeFiCoinType
    public let tvl: Decimal
    public let tvlRank: Int
    public let tvlChange1d: Decimal?
    public let tvlChange1w: Decimal?
    public let tvlChange2w: Decimal?
    public let tvlChange1m: Decimal?
    public let tvlChange3m: Decimal?
    public let tvlChange6m: Decimal?
    public let tvlChange1y: Decimal?
    public let chains: [String]
    public let chainTvls: [String: Decimal]
}

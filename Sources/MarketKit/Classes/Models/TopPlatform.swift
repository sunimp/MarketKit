//
//  TopPlatform.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public struct TopPlatform {
    public let blockchain: Blockchain
    public let rank: Int?
    public let protocolsCount: Int?
    public let marketCap: Decimal?

    public let ranks: [WWTimePeriod: Int]
    public let changes: [WWTimePeriod: Decimal]
}

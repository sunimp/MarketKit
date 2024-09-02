//
//  TopPlatform.swift
//
//  Created by Sun on 2022/5/4.
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

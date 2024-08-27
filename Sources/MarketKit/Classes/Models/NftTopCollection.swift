//
//  NftTopCollection.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public struct NftTopCollection {
    public let blockchainType: BlockchainType
    public let providerUid: String
    public let name: String
    public let thumbnailImageUrl: String?
    public let floorPrice: NftPrice?
    public let volumes: [WWTimePeriod: NftPrice]
    public let changes: [WWTimePeriod: Decimal]
}

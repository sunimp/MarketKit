//
//  NftTopCollection.swift
//
//  Created by Sun on 2022/9/2.
//

import Foundation

public struct NftTopCollection {
    public let blockchainType: BlockchainType
    public let providerUid: String
    public let name: String
    public let thumbnailImageURL: String?
    public let floorPrice: NftPrice?
    public let volumes: [WWTimePeriod: NftPrice]
    public let changes: [WWTimePeriod: Decimal]
}

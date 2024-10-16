//
//  NFTTopCollection.swift
//  MarketKit
//
//  Created by Sun on 2022/9/2.
//

import Foundation

public struct NFTTopCollection {
    public let blockchainType: BlockchainType
    public let providerUid: String
    public let name: String
    public let thumbnailImageURL: String?
    public let floorPrice: NFTPrice?
    public let volumes: [SWTimePeriod: NFTPrice]
    public let changes: [SWTimePeriod: Decimal]
}

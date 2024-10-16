//
//  SWNFTProvider.swift
//  MarketKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import Alamofire
import ObjectMapper
import SWToolKit

// MARK: - SWNFTProvider

class SWNFTProvider {
    // MARK: Properties

    private let baseURL: String
    private let networkManager: NetworkManager
    private let headers: HTTPHeaders?
    private let encoding: ParameterEncoding = URLEncoding(boolEncoding: .literal)

    // MARK: Lifecycle

    init(baseURL: String, networkManager: NetworkManager, apiKey: String?) {
        self.baseURL = baseURL
        self.networkManager = networkManager

        headers = apiKey.flatMap { HTTPHeaders([HTTPHeader(name: "apikey", value: $0)]) }
    }
}

extension SWNFTProvider {
    func topCollections() async throws -> [NFTTopCollectionResponse] {
        let parameters: Parameters = [
            "simplified": true,
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/nft/collections",
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
}

// MARK: - NFTTopCollectionResponse

struct NFTTopCollectionResponse: ImmutableMappable {
    // MARK: Properties

    let blockchainUid: String
    let providerUid: String
    let name: String
    let thumbnailImageURL: String?
    let floorPrice: Decimal?
    let volume1d: Decimal?
    let change1d: Decimal?
    let volume7d: Decimal?
    let change7d: Decimal?
    let volume30d: Decimal?
    let change30d: Decimal?

    // MARK: Lifecycle

    init(map: Map) throws {
        blockchainUid = try map.value("blockchain_uid")
        providerUid = try map.value("opensea_uid")
        name = try map.value("name")
        thumbnailImageURL = try? map.value("thumbnail_url")
        floorPrice = try? map.value("floor_price", using: Transform.doubleToDecimalTransform)
        volume1d = try? map.value("volume_1d", using: Transform.doubleToDecimalTransform)
        change1d = try? map.value("change_1d", using: Transform.doubleToDecimalTransform)
        volume7d = try? map.value("volume_7d", using: Transform.doubleToDecimalTransform)
        change7d = try? map.value("change_7d", using: Transform.doubleToDecimalTransform)
        volume30d = try? map.value("volume_30d", using: Transform.doubleToDecimalTransform)
        change30d = try? map.value("change_30d", using: Transform.doubleToDecimalTransform)
    }
}

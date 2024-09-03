//
//  NFTManager.swift
//
//  Created by Sun on 2022/5/24.
//

import Foundation

// MARK: - NFTManager

class NFTManager {
    // MARK: Properties

    private let coinManager: CoinManager
    private let provider: WWNFTProvider

    // MARK: Lifecycle

    init(coinManager: CoinManager, provider: WWNFTProvider) {
        self.coinManager = coinManager
        self.provider = provider
    }

    // MARK: Functions

    private func nftPrice(token: Token?, value: Decimal?) -> NFTPrice? {
        guard let token, let value else {
            return nil
        }

        return NFTPrice(token: token, value: value)
    }

    private func baseTokenMap(blockchainTypes: [BlockchainType]) -> [BlockchainType: Token] {
        do {
            var map = [BlockchainType: Token]()
            let tokens = try coinManager
                .tokens(queries: blockchainTypes.map { TokenQuery(blockchainType: $0, tokenType: .native) })

            for token in tokens {
                map[token.blockchainType] = token
            }

            return map
        } catch {
            return [:]
        }
    }

    private func collection(
        response: NFTTopCollectionResponse,
        baseTokenMap: [BlockchainType: Token]
    )
        -> NFTTopCollection {
        let blockchainType = BlockchainType(uid: response.blockchainUid)
        let baseToken = baseTokenMap[blockchainType]

        let volumes: [WWTimePeriod: NFTPrice?] = [
            .day1: nftPrice(token: baseToken, value: response.volume1d),
            .week1: nftPrice(token: baseToken, value: response.volume7d),
            .month1: nftPrice(token: baseToken, value: response.volume30d),
        ]

        let changes: [WWTimePeriod: Decimal?] = [
            .day1: response.change1d,
            .week1: response.change7d,
            .month1: response.change30d,
        ]

        return NFTTopCollection(
            blockchainType: blockchainType,
            providerUid: response.providerUid,
            name: response.name,
            thumbnailImageURL: response.thumbnailImageURL,
            floorPrice: nftPrice(token: baseToken, value: response.floorPrice),
            volumes: volumes.compactMapValues { $0 },
            changes: changes.compactMapValues { $0 }
        )
    }
}

extension NFTManager {
    func topCollections(responses: [NFTTopCollectionResponse]) -> [NFTTopCollection] {
        let blockchainUids = Array(Set(responses.map(\.blockchainUid)))
        let blockchainTypes = blockchainUids.map { BlockchainType(uid: $0) }
        let baseTokenMap = baseTokenMap(blockchainTypes: blockchainTypes)

        return responses.map { response in
            collection(response: response, baseTokenMap: baseTokenMap)
        }
    }

    func topCollections() async throws -> [NFTTopCollection] {
        let responses = try await provider.topCollections()
        return topCollections(responses: responses)
    }
}

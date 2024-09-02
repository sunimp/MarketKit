//
//  TokenQuery.swift
//
//  Created by Sun on 2022/6/6.
//

import Foundation

// MARK: - TokenQuery

public struct TokenQuery {
    // MARK: Properties

    public let blockchainType: BlockchainType
    public let tokenType: TokenType

    // MARK: Computed Properties

    public var id: String {
        [blockchainType.uid, tokenType.id].joined(separator: "|")
    }

    // MARK: Lifecycle

    public init(blockchainType: BlockchainType, tokenType: TokenType) {
        self.blockchainType = blockchainType
        self.tokenType = tokenType
    }

    public init?(id: String) {
        let chunks = id.split(separator: "|").map { String($0) }

        guard chunks.count == 2, let tokenType = TokenType(id: chunks[1]) else {
            return nil
        }

        self.init(
            blockchainType: BlockchainType(uid: chunks[0]),
            tokenType: tokenType
        )
    }
}

// MARK: Hashable

extension TokenQuery: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(blockchainType)
        hasher.combine(tokenType)
    }
}

// MARK: Equatable

extension TokenQuery: Equatable {
    public static func == (lhs: TokenQuery, rhs: TokenQuery) -> Bool {
        lhs.blockchainType == rhs.blockchainType && lhs.tokenType == rhs.tokenType
    }
}

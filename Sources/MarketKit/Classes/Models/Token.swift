//
//  Token.swift
//
//  Created by Sun on 2022/6/6.
//

import Foundation

// MARK: - Token

public struct Token {
    // MARK: Properties

    public let coin: Coin
    public let blockchain: Blockchain
    public let type: TokenType
    public let decimals: Int

    // MARK: Computed Properties

    public var blockchainType: BlockchainType {
        blockchain.type
    }

    public var tokenQuery: TokenQuery {
        TokenQuery(blockchainType: blockchainType, tokenType: type)
    }

    public var fullCoin: FullCoin {
        FullCoin(coin: coin, tokens: [self])
    }

    // MARK: Lifecycle

    public init(coin: Coin, blockchain: Blockchain, type: TokenType, decimals: Int) {
        self.coin = coin
        self.blockchain = blockchain
        self.type = type
        self.decimals = decimals
    }
}

// MARK: Hashable

extension Token: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(coin)
        hasher.combine(blockchain)
        hasher.combine(type)
        hasher.combine(decimals)
    }
}

// MARK: Equatable

extension Token: Equatable {
    public static func == (lhs: Token, rhs: Token) -> Bool {
        lhs.coin == rhs.coin
            && lhs.blockchain == rhs.blockchain
            && lhs.type == rhs.type
            && lhs.decimals == rhs.decimals
    }
}

// MARK: CustomStringConvertible

extension Token: CustomStringConvertible {
    public var description: String {
        "Token [coin: \(coin); blockchain: \(blockchain); type: \(type); decimals: \(decimals)]"
    }
}

//
//  BlockchainType.swift
//  MarketKit
//
//  Created by Sun on 2022/6/6.
//

import Foundation

// MARK: - BlockchainType

public enum BlockchainType {
    case bitcoin
    case bitcoinCash
    case ecash
    case litecoin
    case dash
    case zcash
    case ethereum
    case binanceSmartChain
    case binanceChain
    case polygon
    case avalanche
    case optimism
    case arbitrumOne
    case gnosis
    case fantom
    case tron
    case solana
    case ton
    case base
    case unsupported(uid: String)

    // MARK: Computed Properties

    public var uid: String {
        switch self {
        case .bitcoin: "bitcoin"
        case .bitcoinCash: "bitcoin-cash"
        case .ecash: "ecash"
        case .litecoin: "litecoin"
        case .dash: "dash"
        case .zcash: "zcash"
        case .ethereum: "ethereum"
        case .binanceSmartChain: "binance-smart-chain"
        case .binanceChain: "binancecoin"
        case .polygon: "polygon-pos"
        case .avalanche: "avalanche"
        case .optimism: "optimistic-ethereum"
        case .arbitrumOne: "arbitrum-one"
        case .gnosis: "gnosis"
        case .fantom: "fantom"
        case .tron: "tron"
        case .solana: "solana"
        case .ton: "the-open-network"
        case .base: "base"
        case let .unsupported(uid): uid
        }
    }

    // MARK: Lifecycle

    public init(uid: String) {
        switch uid {
        case "bitcoin": self = .bitcoin
        case "bitcoin-cash": self = .bitcoinCash
        case "ecash": self = .ecash
        case "litecoin": self = .litecoin
        case "dash": self = .dash
        case "zcash": self = .zcash
        case "ethereum": self = .ethereum
        case "binance-smart-chain": self = .binanceSmartChain
        case "binancecoin": self = .binanceChain
        case "polygon-pos": self = .polygon
        case "avalanche": self = .avalanche
        case "optimistic-ethereum": self = .optimism
        case "arbitrum-one": self = .arbitrumOne
        case "gnosis": self = .gnosis
        case "fantom": self = .fantom
        case "tron": self = .tron
        case "solana": self = .solana
        case "the-open-network": self = .ton
        case "base": self = .base
        default: self = .unsupported(uid: uid)
        }
    }
}

// MARK: Hashable

extension BlockchainType: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}

// MARK: Equatable

extension BlockchainType: Equatable {
    public static func == (lhs: BlockchainType, rhs: BlockchainType) -> Bool {
        lhs.uid == rhs.uid
    }
}

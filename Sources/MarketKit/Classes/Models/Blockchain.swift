//
//  Blockchain.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - Blockchain

public struct Blockchain {
    
    public let type: BlockchainType
    public let name: String
    public let explorerURL: String?

    public init(type: BlockchainType, name: String, explorerURL: String?) {
        self.type = type
        self.name = name
        self.explorerURL = explorerURL
    }

    public var uid: String {
        type.uid
    }
}

// MARK: Hashable

extension Blockchain: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }
}

// MARK: Equatable

extension Blockchain: Equatable {
    public static func == (lhs: Blockchain, rhs: Blockchain) -> Bool {
        lhs.type == rhs.type
    }
}

// MARK: CustomStringConvertible

extension Blockchain: CustomStringConvertible {
    public var description: String {
        "Blockchain [type: \(type); name: \(name); explorerUrl: \(explorerURL ?? "nil")]"
    }
}

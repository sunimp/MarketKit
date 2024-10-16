//
//  Blockchain.swift
//  MarketKit
//
//  Created by Sun on 2022/6/6.
//

import Foundation

// MARK: - Blockchain

public struct Blockchain {
    // MARK: Properties

    public let type: BlockchainType
    public let name: String
    public let explorerURL: String?

    // MARK: Computed Properties

    public var uid: String {
        type.uid
    }

    // MARK: Lifecycle

    public init(type: BlockchainType, name: String, explorerURL: String?) {
        self.type = type
        self.name = name
        self.explorerURL = explorerURL
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

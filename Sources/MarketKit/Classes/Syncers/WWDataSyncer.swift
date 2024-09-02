//
//  WWDataSyncer.swift
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import WWExtensions

// MARK: - WWDataSyncer

class WWDataSyncer {
    // MARK: Properties

    private let coinSyncer: CoinSyncer
    private let provider: WWProvider
    private var tasks = Set<AnyTask>()

    // MARK: Lifecycle

    init(coinSyncer: CoinSyncer, provider: WWProvider) {
        self.coinSyncer = coinSyncer
        self.provider = provider
    }
}

extension WWDataSyncer {
    func sync() {
        Task { [provider, coinSyncer] in
            do {
                let status = try await provider.status()
                coinSyncer.sync(
                    coinsTimestamp: status.coins,
                    blockchainsTimestamp: status.blockchains,
                    tokensTimestamp: status.tokens
                )
            } catch {
                print("WW Status sync error: \(error)")
            }
        }.store(in: &tasks)
    }
}

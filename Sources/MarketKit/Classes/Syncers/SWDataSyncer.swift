//
//  SWDataSyncer.swift
//  MarketKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import SWExtensions

// MARK: - SWDataSyncer

class SWDataSyncer {
    // MARK: Properties

    private let coinSyncer: CoinSyncer
    private let provider: SWProvider
    private var tasks = Set<AnyTask>()

    // MARK: Lifecycle

    init(coinSyncer: CoinSyncer, provider: SWProvider) {
        self.coinSyncer = coinSyncer
        self.provider = provider
    }
}

extension SWDataSyncer {
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
                print("SWStatus sync error: \(error)")
            }
        }.store(in: &tasks)
    }
}

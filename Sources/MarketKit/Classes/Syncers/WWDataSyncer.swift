//
//  WWDataSyncer.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import WWExtensions

class WWDataSyncer {
    private let coinSyncer: CoinSyncer
    private let provider: WWProvider
    private var tasks = Set<AnyTask>()

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
                coinSyncer.sync(coinsTimestamp: status.coins, blockchainsTimestamp: status.blockchains, tokensTimestamp: status.tokens)
            } catch {
                print("WW Status sync error: \(error)")
            }
        }.store(in: &tasks)
    }
}

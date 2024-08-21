//
//  PostManager.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

class PostManager {
    private let provider: CryptoCompareProvider

    init(provider: CryptoCompareProvider) {
        self.provider = provider
    }
}

extension PostManager {
    func posts() async throws -> [Post] {
        try await provider.posts()
    }
}

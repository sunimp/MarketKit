//
//  PostManager.swift
//
//  Created by Sun on 2021/9/29.
//

import Foundation

// MARK: - PostManager

class PostManager {
    // MARK: Properties

    private let provider: CryptoCompareProvider

    // MARK: Lifecycle

    init(provider: CryptoCompareProvider) {
        self.provider = provider
    }
}

extension PostManager {
    func posts() async throws -> [Post] {
        try await provider.posts()
    }
}

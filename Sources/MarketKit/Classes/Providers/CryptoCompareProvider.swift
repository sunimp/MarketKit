//
//  CryptoCompareProvider.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import Alamofire
import WWToolKit

// MARK: - CryptoCompareProvider

class CryptoCompareProvider {
    private let baseURL = "https://min-api.cryptocompare.com"

    private let networkManager: NetworkManager
    private let apiKey: String?

    init(networkManager: NetworkManager, apiKey: String?) {
        self.networkManager = networkManager
        self.apiKey = apiKey
    }
}

extension CryptoCompareProvider {
    func posts() async throws -> [Post] {
        var parameters: Parameters = [
            "excludeCategories": "Sponsored",
            "feeds": "cointelegraph,theblock,decrypt",
            "extraParams": "Blocksdecoded",
        ]

        parameters["api_key"] = apiKey

        let postsResponse: PostsResponse = try await networkManager.fetch(
            url: "\(baseURL)/data/v2/news/",
            method: .get,
            parameters: parameters,
            interceptor: RateLimitRetrier(),
            responseCacherBehavior: .doNotCache
        )
        return postsResponse.posts
    }
}

// MARK: CryptoCompareProvider.RateLimitRetrier

extension CryptoCompareProvider {
    class RateLimitRetrier: RequestInterceptor {
        private var attempt = 0

        func retry(_: Request, for _: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
            let error = NetworkManager.unwrap(error: error)

            if case RequestError.rateLimitExceeded = error {
                completion(resolveResult())
            } else {
                completion(.doNotRetry)
            }
        }

        private func resolveResult() -> RetryResult {
            attempt += 1

            if attempt == 1 { return .retryWithDelay(3) }
            if attempt == 2 { return .retryWithDelay(6) }

            return .doNotRetry
        }
    }
}

// MARK: CryptoCompareProvider.RequestError

extension CryptoCompareProvider {
    enum RequestError: Error {
        case rateLimitExceeded
    }
}

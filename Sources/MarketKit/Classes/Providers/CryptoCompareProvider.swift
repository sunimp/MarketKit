//
//  CryptoCompareProvider.swift
//  MarketKit
//
//  Created by Sun on 2021/9/29.
//

import Foundation

import Alamofire
import SWToolKit

// MARK: - CryptoCompareProvider

class CryptoCompareProvider {
    // MARK: Properties

    private let baseURL = "https://min-api.cryptocompare.com"

    private let networkManager: NetworkManager
    private let apiKey: String?

    // MARK: Lifecycle

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
    class RateLimitRetrier: RequestInterceptor, @unchecked Sendable {
        // MARK: Properties

        private var attempt = 0

        // MARK: Functions

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

            if attempt == 1 {
                return .retryWithDelay(3)
            }
            if attempt == 2 {
                return .retryWithDelay(6)
            }

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

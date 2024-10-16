//
//  SWProvider.swift
//  MarketKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import Alamofire
import ObjectMapper
import SWToolKit

// MARK: - SWProvider

class SWProvider {
    // MARK: Properties

    var proAuthToken: String?

    private let baseURL: String
    private let networkManager: NetworkManager
    private let apiKey: String?

    // MARK: Computed Properties

    var headers: HTTPHeaders {
        var headers = HTTPHeaders()

        if let apiKey {
            headers.add(name: "apikey", value: apiKey)
        }

        return headers
    }

    var proHeaders: HTTPHeaders {
        var headers = headers

        if let proAuthToken {
            headers.add(.authorization(proAuthToken))
        }

        return headers
    }

    // MARK: Lifecycle

    init(baseURL: String, networkManager: NetworkManager, apiKey: String?) {
        self.baseURL = baseURL
        self.networkManager = networkManager
        self.apiKey = apiKey
    }
}

extension SWProvider {
    func marketGlobal(currencyCode: String) async throws -> MarketGlobal {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/markets/overview-simple",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func marketOverview(currencyCode: String) async throws -> MarketOverviewResponse {
        let parameters: Parameters = [
            "simplified": true,
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/markets/overview",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func topMoversRaw(currencyCode: String) async throws -> TopMoversRaw {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/coins/top-movers",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    // Status

    func status() async throws -> SWStatus {
        try await networkManager.fetch(url: "\(baseURL)/v1/status/updates", method: .get, headers: headers)
    }

    // Coins

    func allCoins() async throws -> [Coin] {
        try await networkManager.fetch(url: "\(baseURL)/v1/coins/list", method: .get, headers: headers)
    }

    func allBlockchainRecords() async throws -> [BlockchainRecord] {
        try await networkManager.fetch(url: "\(baseURL)/v1/blockchains/list", method: .get, headers: headers)
    }

    func allTokenRecords() async throws -> [TokenRecord] {
        try await networkManager.fetch(url: "\(baseURL)/v1/tokens/list", method: .get, headers: headers)
    }

    // Market Infos

    func marketInfos(top: Int, currencyCode: String, defi: Bool) async throws -> [MarketInfoRaw] {
        var parameters: Parameters = [
            "limit": top,
            "fields": "price,price_change_24h,price_change_1d,market_cap,market_cap_rank,total_volume",
            "currency": currencyCode.lowercased(),
            "order_by_rank": "true",
        ]

        if defi {
            parameters["defi"] = "true"
        }

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/coins",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func topCoinsMarketInfos(top: Int, currencyCode: String) async throws -> [MarketInfoRaw] {
        let parameters: Parameters = [
            "limit": top,
            "fields": "price,price_change_24h,price_change_1d,price_change_7d,price_change_30d,price_change_90d,market_cap,market_cap_rank,total_volume",
            "currency": currencyCode.lowercased(),
            "order_by_rank": "true",
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/coins",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func advancedMarketInfos(top: Int, currencyCode: String) async throws -> [MarketInfoRaw] {
        let parameters: Parameters = [
            "limit": top,
            "currency": currencyCode.lowercased(),
            "order_by_rank": "true",
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/coins/filter",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func marketInfos(coinUids: [String], currencyCode: String) async throws -> [MarketInfoRaw] {
        let parameters: Parameters = [
            "uids": coinUids.joined(separator: ","),
            "fields": "price,price_change_24h,price_change_1d,price_change_7d,price_change_30d,price_change_90d,market_cap,market_cap_rank,total_volume",
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/coins",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func marketInfos(categoryUid: String, currencyCode: String) async throws -> [MarketInfoRaw] {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/categories/\(categoryUid)/coins",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func marketInfoOverview(
        coinUid: String,
        currencyCode: String,
        languageCode: String
    ) async throws
        -> MarketInfoOverviewResponse {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
            "language": languageCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/coins/\(coinUid)",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func marketInfoTvl(coinUid: String, currencyCode: String, timePeriod: SWTimePeriod) async throws -> [ChartPoint] {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
            "interval": timePeriod.rawValue,
        ]

        let response: [MarketInfoTvlRaw] = try await networkManager.fetch(
            url: "\(baseURL)/v1/defi-protocols/\(coinUid)/tvls",
            method: .get,
            parameters: parameters,
            headers: headers
        )
        return response.compactMap(\.marketInfoTvl)
    }

    func marketInfoGlobalTvl(
        platform: String,
        currencyCode: String,
        timePeriod: SWTimePeriod
    ) async throws
        -> [ChartPoint] {
        var parameters: Parameters = [
            "currency": currencyCode.lowercased(),
            "interval": timePeriod.rawValue,
        ]

        if !platform.isEmpty {
            parameters["chain"] = platform
        }

        let response: [MarketInfoTvlRaw] = try await networkManager.fetch(
            url: "\(baseURL)/v1/global-markets/tvls",
            method: .get,
            parameters: parameters,
            headers: headers
        )
        return response.compactMap(\.marketInfoTvl)
    }

    func defiCoins(currencyCode: String) async throws -> [DeFiCoinRaw] {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/defi-protocols/list",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    // Coin Categories

    func coinCategories(currencyCode: String? = nil) async throws -> [CoinCategory] {
        var parameters: Parameters = [:]
        if let currencyCode {
            parameters["currency"] = currencyCode.lowercased()
        }

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/categories",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func coinCategoryMarketCapChart(
        category: String,
        currencyCode: String?,
        timePeriod: SWTimePeriod
    ) async throws
        -> [CategoryMarketPoint] {
        var parameters: Parameters = [:]
        if let currencyCode {
            parameters["currency"] = currencyCode.lowercased()
        }
        parameters["interval"] = timePeriod.rawValue

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/categories/\(category)/market_cap",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    // Coin Prices

    func coinPrices(coinUids: [String], walletCoinUids: [String], currencyCode: String) async throws -> [CoinPrice] {
        var parameters: Parameters = [
            "uids": coinUids.joined(separator: ","),
            "currency": currencyCode.lowercased(),
            "fields": "price,price_change_24h,price_change_1d,last_updated",
        ]

        if !walletCoinUids.isEmpty {
            parameters["enabled_uids"] = walletCoinUids.joined(separator: ",")
        }

        let responses: [CoinPriceResponse] = try await networkManager.fetch(
            url: "\(baseURL)/v1/coins",
            method: .get,
            parameters: parameters,
            headers: headers
        )
        return responses.map { $0.coinPrice(currencyCode: currencyCode) }
    }

    func historicalCoinPrice(
        coinUid: String,
        currencyCode: String,
        timestamp: TimeInterval
    ) async throws
        -> HistoricalCoinPriceResponse {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
            "timestamp": Int(timestamp),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/coins/\(coinUid)/price_history",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func coinPriceChartStart(coinUid: String) async throws -> ChartStart {
        try await networkManager.fetch(
            url: "\(baseURL)/v1/coins/\(coinUid)/price_chart_start",
            method: .get,
            headers: headers
        )
    }

    func topPlatformMarketCapStart(platform: String) async throws -> ChartStart {
        try await networkManager.fetch(
            url: "\(baseURL)/v1/top-platforms/\(platform)/market_chart_start",
            method: .get,
            headers: headers
        )
    }

    func coinPriceChart(
        coinUid: String,
        currencyCode: String,
        interval: SWPointTimePeriod,
        fromTimestamp: TimeInterval? = nil
    ) async throws
        -> [ChartCoinPriceResponse] {
        var parameters: Parameters = [
            "currency": currencyCode.lowercased(),
            "interval": interval.rawValue,
        ]

        if let fromTimestamp {
            parameters["from_timestamp"] = Int(fromTimestamp)
        }

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/coins/\(coinUid)/price_chart",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    // Holders

    func tokenHolders(coinUid: String, blockchainUid: String) async throws -> TokenHolders {
        let parameters: Parameters = [
            "blockchain_uid": blockchainUid,
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/analytics/\(coinUid)/holders",
            method: .get,
            parameters: parameters,
            headers: proHeaders
        )
    }

    // Funds

    func coinInvestments(coinUid: String) async throws -> [CoinInvestment] {
        let parameters: Parameters = [
            "coin_uid": coinUid,
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/funds/investments",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func coinTreasuries(coinUid: String, currencyCode: String) async throws -> [CoinTreasury] {
        let parameters: Parameters = [
            "coin_uid": coinUid,
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/funds/treasuries",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func coinReports(coinUid: String) async throws -> [CoinReport] {
        let parameters: Parameters = [
            "coin_uid": coinUid,
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/reports",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func twitterUsername(coinUid: String) async throws -> String? {
        let response: TwitterUsernameResponse = try await networkManager.fetch(
            url: "\(baseURL)/v1/coins/\(coinUid)/twitter",
            method: .get,
            headers: headers
        )
        return response.username
    }

    func globalMarketPoints(currencyCode: String, timePeriod: SWTimePeriod) async throws -> [GlobalMarketPoint] {
        let parameters: Parameters = [
            "interval": timePeriod.rawValue,
            "currency": currencyCode,
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/global-markets",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    // Top Pairs

    func topPairs(currencyCode: String) async throws -> [MarketPairResponse] {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/exchanges/top-market-pairs",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    // Top Platforms

    func topPlatforms(currencyCode: String) async throws -> [TopPlatformResponse] {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/top-platforms",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func topPlatformCoinsList(blockchain: String, currencyCode: String) async throws -> [MarketInfoRaw] {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/top-platforms/\(blockchain)/list",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func topPlatformMarketCapChart(
        platform: String,
        currencyCode: String?,
        interval: SWPointTimePeriod,
        fromTimestamp: TimeInterval? = nil
    ) async throws
        -> [CategoryMarketPoint] {
        var parameters: Parameters = [
            "interval": interval.rawValue,
        ]
        if let currencyCode {
            parameters["currency"] = currencyCode.lowercased()
        }
        if let fromTimestamp {
            parameters["from_timestamp"] = Int(fromTimestamp)
        }

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/top-platforms/\(platform)/market_chart",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    // ETF

    func etfs(currencyCode: String) async throws -> [ETF] {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/etfs",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func etfPoints(currencyCode: String) async throws -> [ETFPoint] {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/etfs/total",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    // Pro Charts

    private func proData<T: ImmutableMappable>(
        path: String,
        currencyCode: String,
        timePeriod: SWTimePeriod
    ) async throws
        -> [T] {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
            "interval": timePeriod.rawValue,
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/analytics/\(path)",
            method: .get,
            parameters: parameters,
            headers: proHeaders
        )
    }

    private func proData<T: ImmutableMappable>(path: String, timePeriod: SWTimePeriod) async throws -> [T] {
        let parameters: Parameters = [
            "interval": timePeriod.rawValue,
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/analytics/\(path)",
            method: .get,
            parameters: parameters,
            headers: proHeaders
        )
    }

    private func rankData<T: ImmutableMappable>(type: String, currencyCode: String? = nil) async throws -> [T] {
        var parameters: Parameters = [
            "type": type,
        ]

        if let currencyCode {
            parameters["currency"] = currencyCode.lowercased()
        }

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/analytics/ranks",
            method: .get,
            parameters: parameters,
            headers: proHeaders
        )
    }

    func analytics(coinUid: String, currencyCode: String) async throws -> Analytics {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
        ]
        return try await networkManager.fetch(
            url: "\(baseURL)/v1/analytics/\(coinUid)",
            method: .get,
            parameters: parameters,
            headers: proHeaders
        )
    }

    func analyticsPreview(coinUid: String) async throws -> AnalyticsPreview {
        try await networkManager.fetch(
            url: "\(baseURL)/v1/analytics/\(coinUid)/preview",
            method: .get,
            headers: headers
        )
    }

    func dexVolumes(coinUid: String, currencyCode: String, timePeriod: SWTimePeriod) async throws -> [VolumePoint] {
        try await proData(path: "\(coinUid)/dex-volumes", currencyCode: currencyCode, timePeriod: timePeriod)
    }

    func dexLiquidity(coinUid: String, currencyCode: String, timePeriod: SWTimePeriod) async throws -> [VolumePoint] {
        try await proData(path: "\(coinUid)/dex-liquidity", currencyCode: currencyCode, timePeriod: timePeriod)
    }

    func activeAddresses(coinUid: String, timePeriod: SWTimePeriod) async throws -> [CountPoint] {
        try await proData(path: "\(coinUid)/addresses", timePeriod: timePeriod)
    }

    func transactions(coinUid: String, timePeriod: SWTimePeriod) async throws -> [CountVolumePoint] {
        try await proData(path: "\(coinUid)/transactions", timePeriod: timePeriod)
    }

    func cexVolumeRanks(currencyCode: String) async throws -> [RankMultiValue] {
        try await rankData(type: "cex_volume", currencyCode: currencyCode)
    }

    func dexVolumeRanks(currencyCode: String) async throws -> [RankMultiValue] {
        try await rankData(type: "dex_volume", currencyCode: currencyCode)
    }

    func dexLiquidityRanks() async throws -> [RankValue] {
        try await rankData(type: "dex_liquidity")
    }

    func activeAddressRanks() async throws -> [RankMultiValue] {
        try await rankData(type: "address")
    }

    func transactionCountRanks() async throws -> [RankMultiValue] {
        try await rankData(type: "tx_count")
    }

    func holdersRanks() async throws -> [RankValue] {
        try await rankData(type: "holders")
    }

    func feeRanks(currencyCode: String) async throws -> [RankMultiValue] {
        try await rankData(type: "fee", currencyCode: currencyCode)
    }

    func revenueRanks(currencyCode: String) async throws -> [RankMultiValue] {
        try await rankData(type: "revenue", currencyCode: currencyCode)
    }

    // Authentication

    func subscriptions(addresses: [String]) async throws -> [ProSubscription] {
        let parameters: Parameters = [
            "address": addresses.joined(separator: ","),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/analytics/subscriptions",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    func authKey(address: String) async throws -> String {
        let parameters: Parameters = [
            "address": address,
        ]

        let response: SignMessageResponse = try await networkManager.fetch(
            url: "\(baseURL)/v1/auth/get-sign-message",
            method: .get,
            parameters: parameters,
            headers: headers
        )

        return response.message
    }

    func authenticate(signature: String, address: String) async throws -> String {
        let parameters: Parameters = [
            "signature": signature,
            "address": address,
        ]

        let response: AuthenticateResponse = try await networkManager.fetch(
            url: "\(baseURL)/v1/auth/authenticate",
            method: .post,
            parameters: parameters,
            headers: headers
        )

        return response.token
    }

    // Personal Support

    func requestPersonalSupport(telegramUsername: String) async throws {
        let parameters: Parameters = [
            "username": telegramUsername,
        ]

        _ = try await networkManager.fetchJson(
            url: "\(baseURL)/v1/support/start-chat",
            method: .post,
            parameters: parameters,
            headers: proHeaders
        )
    }

    // Market Tickers

    func marketTickers(coinUid: String, currencyCode: String) async throws -> [MarketTicker] {
        let parameters: Parameters = [
            "currency": currencyCode.lowercased(),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/exchanges/tickers/\(coinUid)",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    // Signals

    func signals(coinUids: [String]) async throws -> [SignalResponse] {
        let parameters: Parameters = [
            "uids": coinUids.joined(separator: ","),
        ]

        return try await networkManager.fetch(
            url: "\(baseURL)/v1/coins/signals",
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    // Stats

    func send(stats: Any, appVersion: String, appID: String?) async throws {
        var headers = headers

        headers.add(name: "app_platform", value: "ios")
        headers.add(name: "app_version", value: appVersion)

        if let appID {
            headers.add(name: "app_id", value: appID)
        }

        _ = try await networkManager.fetchJson(
            url: "\(baseURL)/v1/stats",
            method: .post,
            encoding: HttpBodyEncoding(jsonObject: stats),
            headers: headers
        )
    }
}

extension SWProvider {
    struct SignalResponse: ImmutableMappable {
        // MARK: Properties

        let uid: String
        let signal: TechnicalAdvice.Advice?

        // MARK: Lifecycle

        init(map: Map) throws {
            uid = try map.value("uid")
            signal = try TechnicalAdvice.Advice(rawValue: map.value("signal"))
        }
    }

    struct HistoricalCoinPriceResponse: ImmutableMappable {
        // MARK: Properties

        let timestamp: Int
        let price: Decimal

        // MARK: Lifecycle

        init(map: Map) throws {
            timestamp = try map.value("timestamp")
            price = try map.value("price", using: Transform.stringToDecimalTransform)
        }
    }

    struct ChartCoinPriceResponse: ImmutableMappable {
        // MARK: Properties

        let timestamp: Int
        let price: Decimal
        let totalVolume: Decimal?

        // MARK: Computed Properties

        var chartPoint: ChartPoint {
            ChartPoint(
                timestamp: TimeInterval(timestamp),
                value: price,
                volume: totalVolume
            )
        }

        var volumeChartPoint: ChartPoint? {
            guard let totalVolume else {
                return nil
            }

            return ChartPoint(timestamp: TimeInterval(timestamp), value: totalVolume)
        }

        // MARK: Lifecycle

        init(map: Map) throws {
            timestamp = try map.value("timestamp")
            price = try map.value("price", using: Transform.stringToDecimalTransform)
            totalVolume = try? map.value("volume", using: Transform.stringToDecimalTransform)
        }
    }

    struct SignMessageResponse: ImmutableMappable {
        // MARK: Properties

        let message: String

        // MARK: Lifecycle

        init(map: Map) throws {
            message = try map.value("message")
        }
    }

    struct AuthenticateResponse: ImmutableMappable {
        // MARK: Properties

        let token: String

        // MARK: Lifecycle

        init(map: Map) throws {
            token = try map.value("token")
        }
    }

    private struct HttpBodyEncoding: ParameterEncoding, @unchecked Sendable {
        // MARK: Properties

        private let jsonObject: Any

        // MARK: Lifecycle

        init(jsonObject: Any) {
            self.jsonObject = jsonObject
        }

        // MARK: Functions

        func encode(_ urlRequest: URLRequestConvertible, with _: Parameters?) throws -> URLRequest {
            var urlRequest = try urlRequest.asURLRequest()

            let data = try JSONSerialization.data(withJSONObject: jsonObject)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data

            return urlRequest
        }
    }
}

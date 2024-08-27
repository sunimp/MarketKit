//
//  Kit.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Combine
import Foundation

// MARK: - Kit

public class Kit {
    
    private let coinManager: CoinManager
    private let nftManager: NftManager
    private let marketOverviewManager: MarketOverviewManager
    private let dataSyncer: WWDataSyncer
    private let coinSyncer: CoinSyncer
    private let coinPriceManager: CoinPriceManager
    private let coinPriceSyncManager: CoinPriceSyncManager
    private let coinHistoricalPriceManager: CoinHistoricalPriceManager
    private let postManager: PostManager
    private let globalMarketInfoManager: GlobalMarketInfoManager
    private let provider: WWProvider

    init(
        coinManager: CoinManager,
        nftManager: NftManager,
        marketOverviewManager: MarketOverviewManager,
        dataSyncer: WWDataSyncer,
        coinSyncer: CoinSyncer,
        coinPriceManager: CoinPriceManager,
        coinPriceSyncManager: CoinPriceSyncManager,
        coinHistoricalPriceManager: CoinHistoricalPriceManager,
        postManager: PostManager,
        globalMarketInfoManager: GlobalMarketInfoManager,
        provider: WWProvider
    ) {
        self.coinManager = coinManager
        self.nftManager = nftManager
        self.marketOverviewManager = marketOverviewManager
        self.dataSyncer = dataSyncer
        self.coinSyncer = coinSyncer
        self.coinPriceManager = coinPriceManager
        self.coinPriceSyncManager = coinPriceSyncManager
        self.coinHistoricalPriceManager = coinHistoricalPriceManager
        self.postManager = postManager
        self.globalMarketInfoManager = globalMarketInfoManager
        self.provider = provider

        coinSyncer.initialSync()
    }
}

extension Kit {
    
    public func sync() {
        dataSyncer.sync()
    }

    public func set(proAuthToken: String?) {
        provider.proAuthToken = proAuthToken
    }

    // Coins

    public var fullCoinsUpdatedPublisher: AnyPublisher<Void, Never> {
        coinSyncer.fullCoinsUpdatedPublisher
    }

    public func topFullCoins(limit: Int = 20) throws -> [FullCoin] {
        try coinManager.topFullCoins(limit: limit)
    }

    public func fullCoins(filter: String, limit: Int = 20) throws -> [FullCoin] {
        try coinManager.fullCoins(filter: filter, limit: limit)
    }

    public func fullCoins(coinUids: [String]) throws -> [FullCoin] {
        try coinManager.fullCoins(coinUids: coinUids)
    }

    public func allCoins() throws -> [Coin] {
        try coinManager.allCoins()
    }

    public func coinsDump() throws -> String? {
        try coinSyncer.coinsDump()
    }

    public func blockchainsDump() throws -> String? {
        try coinSyncer.blockchainsDump()
    }

    public func tokenRecordsDump() throws -> String? {
        try coinSyncer.tokenRecordsDump()
    }

    public func token(query: TokenQuery) throws -> Token? {
        try coinManager.token(query: query)
    }

    public func tokens(queries: [TokenQuery]) throws -> [Token] {
        try coinManager.tokens(queries: queries)
    }

    public func tokens(reference: String) throws -> [Token] {
        try coinManager.tokens(reference: reference)
    }

    public func tokens(blockchainType: BlockchainType, filter: String, limit: Int = 20) throws -> [Token] {
        try coinManager.tokens(blockchainType: blockchainType, filter: filter, limit: limit)
    }

    public func allBlockchains() throws -> [Blockchain] {
        try coinManager.allBlockchains()
    }

    public func blockchains(uids: [String]) throws -> [Blockchain] {
        try coinManager.blockchains(uids: uids)
    }

    public func blockchain(uid: String) throws -> Blockchain? {
        try coinManager.blockchain(uid: uid)
    }

    // Market Info

    public func marketInfos(top: Int = 250, currencyCode: String, defi: Bool = false) async throws -> [MarketInfo] {
        let rawMarketInfos = try await provider.marketInfos(top: top, currencyCode: currencyCode, defi: defi)
        return coinManager.marketInfos(rawMarketInfos: rawMarketInfos)
    }

    public func topCoinsMarketInfos(top: Int, currencyCode: String) async throws -> [MarketInfo] {
        let rawMarketInfos = try await provider.topCoinsMarketInfos(top: top, currencyCode: currencyCode)
        return coinManager.marketInfos(rawMarketInfos: rawMarketInfos)
    }

    public func advancedMarketInfos(top: Int = 250, currencyCode: String) async throws -> [MarketInfo] {
        let rawMarketInfos = try await provider.advancedMarketInfos(top: top, currencyCode: currencyCode)
        return coinManager.marketInfos(rawMarketInfos: rawMarketInfos)
    }

    public func marketInfos(coinUids: [String], currencyCode: String) async throws -> [MarketInfo] {
        let rawMarketInfos = try await provider.marketInfos(coinUids: coinUids, currencyCode: currencyCode)
        return coinManager.marketInfos(rawMarketInfos: rawMarketInfos)
    }

    public func marketInfos(categoryUid: String, currencyCode: String) async throws -> [MarketInfo] {
        let rawMarketInfos = try await provider.marketInfos(categoryUid: categoryUid, currencyCode: currencyCode)
        return coinManager.marketInfos(rawMarketInfos: rawMarketInfos)
    }

    public func marketInfoOverview(
        coinUid: String,
        currencyCode: String,
        languageCode: String
    ) async throws -> MarketInfoOverview {
        let response = try await provider.marketInfoOverview(
            coinUid: coinUid,
            currencyCode: currencyCode,
            languageCode: languageCode
        )

        guard let fullCoin = try? coinManager.fullCoin(uid: coinUid) else {
            throw Kit.KitError.noFullCoin
        }

        return response.marketInfoOverview(fullCoin: fullCoin)
    }

    public func marketTickers(coinUid: String, currencyCode: String) async throws -> [MarketTicker] {
        try await provider.marketTickers(coinUid: coinUid, currencyCode: currencyCode)
    }

    public func tokenHolders(coinUid: String, blockchainUid: String) async throws -> TokenHolders {
        try await provider.tokenHolders(coinUid: coinUid, blockchainUid: blockchainUid)
    }

    public func investments(coinUid: String) async throws -> [CoinInvestment] {
        try await provider.coinInvestments(coinUid: coinUid)
    }

    public func treasuries(coinUid: String, currencyCode: String) async throws -> [CoinTreasury] {
        try await provider.coinTreasuries(coinUid: coinUid, currencyCode: currencyCode)
    }

    public func coinReports(coinUid: String) async throws -> [CoinReport] {
        try await provider.coinReports(coinUid: coinUid)
    }

    public func marketInfoGlobalTvl(
        platform: String,
        currencyCode: String,
        timePeriod: WWTimePeriod
    ) async throws -> [ChartPoint] {
        try await provider.marketInfoGlobalTvl(platform: platform, currencyCode: currencyCode, timePeriod: timePeriod)
    }

    public func defiCoins(currencyCode: String) async throws -> [DefiCoin] {
        let rawDefiCoins = try await provider.defiCoins(currencyCode: currencyCode)
        return coinManager.defiCoins(rawDefiCoins: rawDefiCoins)
    }

    public func twitterUsername(coinUid: String) async throws -> String? {
        try await provider.twitterUsername(coinUid: coinUid)
    }

    // Categories

    public func coinCategories(currencyCode: String) async throws -> [CoinCategory] {
        try await provider.coinCategories(currencyCode: currencyCode)
    }

    public func coinCategoryMarketCapChart(
        category: String,
        currencyCode: String?,
        timePeriod: WWTimePeriod
    ) async throws -> [CategoryMarketPoint] {
        try await provider.coinCategoryMarketCapChart(category: category, currencyCode: currencyCode, timePeriod: timePeriod)
    }

    // Coin Prices

    public func refreshCoinPrices(currencyCode: String) {
        coinPriceSyncManager.refresh(currencyCode: currencyCode)
    }

    public func coinPrice(coinUid: String, currencyCode: String) -> CoinPrice? {
        coinPriceManager.coinPrice(coinUid: coinUid, currencyCode: currencyCode)
    }

    public func coinPriceMap(coinUids: [String], currencyCode: String) -> [String: CoinPrice] {
        coinPriceManager.coinPriceMap(coinUids: coinUids, currencyCode: currencyCode)
    }

    public func coinPricePublisher(coinUid: String, currencyCode: String) -> AnyPublisher<CoinPrice, Never> {
        coinPriceSyncManager.coinPricePublisher(coinUid: coinUid, currencyCode: currencyCode)
    }

    public func coinPriceMapPublisher(coinUids: [String], currencyCode: String) -> AnyPublisher<[String: CoinPrice], Never> {
        coinPriceSyncManager.coinPriceMapPublisher(coinUids: coinUids, currencyCode: currencyCode)
    }

    // Coin Historical Prices

    public func cachedCoinHistoricalPriceValue(coinUid: String, currencyCode: String, timestamp: TimeInterval) -> Decimal? {
        coinHistoricalPriceManager.cachedCoinHistoricalPriceValue(
            coinUid: coinUid,
            currencyCode: currencyCode,
            timestamp: timestamp
        )
    }

    public func coinHistoricalPriceValue(coinUid: String, currencyCode: String, timestamp: TimeInterval) async throws -> Decimal {
        try await coinHistoricalPriceManager.coinHistoricalPriceValue(
            coinUid: coinUid,
            currencyCode: currencyCode,
            timestamp: timestamp
        )
    }

    // Chart Info

    public func chartPriceStart(coinUid: String) async throws -> TimeInterval {
        try await provider.coinPriceChartStart(coinUid: coinUid).timestamp
    }

    public func chartPoints(
        coinUid: String,
        currencyCode: String,
        interval: WWPointTimePeriod,
        pointCount: Int
    ) async throws -> [ChartPoint] {
        let fromTimestamp = Date().timeIntervalSince1970 - interval.interval * TimeInterval(pointCount)

        let points = try await provider.coinPriceChart(
            coinUid: coinUid,
            currencyCode: currencyCode,
            interval: interval,
            fromTimestamp: fromTimestamp
        )
        .map(\.chartPoint)

        return points
    }

    private func intervalData(periodType: WWPeriodType)
        -> (interval: WWPointTimePeriod, timestamp: TimeInterval?, visible: TimeInterval)
    {
        let interval: WWPointTimePeriod

        var fromTimestamp: TimeInterval? = nil
        var visibleTimestamp: TimeInterval = 0 // start timestamp for visible part of chart. Will change only for .byCustomPoints

        switch periodType {
        case .byPeriod(let timePeriod):
            interval = WWChartHelper.pointInterval(timePeriod)
            visibleTimestamp = timePeriod.startTimestamp
            fromTimestamp = visibleTimestamp

        case .byCustomPoints(let timePeriod, let pointCount): // custom points needed to build chart indicators
            interval = WWChartHelper.pointInterval(timePeriod)
            let customPointInterval = interval.interval * TimeInterval(pointCount)
            visibleTimestamp = timePeriod.startTimestamp
            fromTimestamp = visibleTimestamp - customPointInterval

        case .byStartTime(let startTime):
            interval = WWChartHelper.intervalForAll(genesisTime: startTime)
            visibleTimestamp = startTime
        }

        return (interval: interval, timestamp: fromTimestamp, visible: visibleTimestamp)
    }

    public func chartPoints(
        coinUid: String,
        currencyCode: String,
        periodType: WWPeriodType
    ) async throws -> (TimeInterval, [ChartPoint]) {
        let data = intervalData(periodType: periodType)

        let points = try await provider.coinPriceChart(
            coinUid: coinUid,
            currencyCode: currencyCode,
            interval: data.interval,
            fromTimestamp: data.timestamp
        )
        .map(\.chartPoint)

        return (data.visible, points)
    }

    // Posts

    public func posts() async throws -> [Post] {
        try await postManager.posts()
    }

    // Global Market Info

    public func globalMarketPoints(currencyCode: String, timePeriod: WWTimePeriod) async throws -> [GlobalMarketPoint] {
        try await globalMarketInfoManager.globalMarketPoints(currencyCode: currencyCode, timePeriod: timePeriod)
    }

    // Pairs

    public func topPairs(currencyCode: String) async throws -> [MarketPair] {
        let responses = try await provider.topPairs(currencyCode: currencyCode)
        let uids = responses.compactMap(\.baseCoinUid) + responses.compactMap(\.targetCoinUid)
        let coins = try coinManager.coins(uids: Array(Set(uids)))
        let coinsDictionary = Dictionary(grouping: coins, by: { $0.uid })

        return responses.map { response in
            MarketPair(
                base: response.base,
                baseCoinUid: response.baseCoinUid,
                target: response.target,
                targetCoinUid: response.targetCoinUid,
                marketName: response.marketName,
                marketImageURL: response.marketImageURL,
                rank: response.rank,
                volume: response.volume,
                price: response.price,
                tradeURL: response.tradeURL,
                baseCoin: response.baseCoinUid.flatMap { coinsDictionary[$0]?.first },
                targetCoin: response.targetCoinUid.flatMap { coinsDictionary[$0]?.first }
            )
        }
    }

    // Platforms

    public func topPlatforms(currencyCode: String) async throws -> [TopPlatform] {
        let responses = try await provider.topPlatforms(currencyCode: currencyCode)
        return responses.map(\.topPlatform)
    }

    public func topPlatformMarketInfos(blockchain: String, currencyCode: String) async throws -> [MarketInfo] {
        let rawMarketInfos = try await provider.topPlatformCoinsList(blockchain: blockchain, currencyCode: currencyCode)
        return coinManager.marketInfos(rawMarketInfos: rawMarketInfos)
    }

    public func topPlatformMarketCapStart(platform: String) async throws -> TimeInterval {
        try await provider.topPlatformMarketCapStart(platform: platform).timestamp
    }

    public func topPlatformMarketCapChart(
        platform: String,
        currencyCode: String?,
        periodType: WWPeriodType
    ) async throws -> [CategoryMarketPoint] {
        let data = intervalData(periodType: periodType)

        return try await provider.topPlatformMarketCapChart(
            platform: platform,
            currencyCode: currencyCode,
            interval: data.interval,
            fromTimestamp: data.timestamp
        )
    }

    // Etf

    public func etfs(currencyCode: String) async throws -> [Etf] {
        try await provider.etfs(currencyCode: currencyCode)
    }

    public func etfPoints(currencyCode: String) async throws -> [EtfPoint] {
        try await provider.etfPoints(currencyCode: currencyCode)
    }

    // Pro Data

    public func analytics(coinUid: String, currencyCode: String) async throws -> Analytics {
        try await provider.analytics(coinUid: coinUid, currencyCode: currencyCode)
    }

    public func analyticsPreview(coinUid: String) async throws -> AnalyticsPreview {
        try await provider.analyticsPreview(coinUid: coinUid)
    }

    public func cexVolumes(
        coinUid: String,
        currencyCode: String,
        timePeriod: WWTimePeriod
    ) async throws -> AggregatedChartPoints {
        let responses = try await provider.coinPriceChart(
            coinUid: coinUid,
            currencyCode: currencyCode,
            interval: .day1,
            fromTimestamp: timePeriod.startTimestamp
        )

        let points = responses.compactMap(\.volumeChartPoint)

        return AggregatedChartPoints(
            points: points,
            aggregatedValue: points.map(\.value).reduce(0, +)
        )
    }

    public func cexVolumeRanks(currencyCode: String) async throws -> [RankMultiValue] {
        try await provider.cexVolumeRanks(currencyCode: currencyCode)
    }

    public func dexVolumeRanks(currencyCode: String) async throws -> [RankMultiValue] {
        try await provider.dexVolumeRanks(currencyCode: currencyCode)
    }

    public func dexLiquidityRanks() async throws -> [RankValue] {
        try await provider.dexLiquidityRanks()
    }

    public func activeAddressRanks() async throws -> [RankMultiValue] {
        try await provider.activeAddressRanks()
    }

    public func transactionCountRanks() async throws -> [RankMultiValue] {
        try await provider.transactionCountRanks()
    }

    public func holdersRanks() async throws -> [RankValue] {
        try await provider.holdersRanks()
    }

    public func feeRanks(currencyCode: String) async throws -> [RankMultiValue] {
        try await provider.feeRanks(currencyCode: currencyCode)
    }

    public func revenueRanks(currencyCode: String) async throws -> [RankMultiValue] {
        try await provider.revenueRanks(currencyCode: currencyCode)
    }

    public func dexVolumes(
        coinUid: String,
        currencyCode: String,
        timePeriod: WWTimePeriod
    ) async throws -> AggregatedChartPoints {
        let points = try await provider.dexVolumes(coinUid: coinUid, currencyCode: currencyCode, timePeriod: timePeriod)
        return AggregatedChartPoints(
            points: points.map(\.chartPoint),
            aggregatedValue: points.map(\.volume).reduce(0, +)
        )
    }

    public func dexLiquidity(coinUid: String, currencyCode: String, timePeriod: WWTimePeriod) async throws -> [ChartPoint] {
        try await provider.dexLiquidity(coinUid: coinUid, currencyCode: currencyCode, timePeriod: timePeriod)
            .map(\.chartPoint)
    }

    public func activeAddresses(coinUid: String, timePeriod: WWTimePeriod) async throws -> [ChartPoint] {
        try await provider.activeAddresses(coinUid: coinUid, timePeriod: timePeriod)
            .map(\.chartPoint)
    }

    public func transactions(coinUid: String, timePeriod: WWTimePeriod) async throws -> AggregatedChartPoints {
        let points = try await provider.transactions(coinUid: coinUid, timePeriod: timePeriod)
        return AggregatedChartPoints(
            points: points.map(\.chartPoint),
            aggregatedValue: points.map(\.count).reduce(0, +)
        )
    }

    public func marketInfoTvl(coinUid: String, currencyCode: String, timePeriod: WWTimePeriod) async throws -> [ChartPoint] {
        try await provider.marketInfoTvl(coinUid: coinUid, currencyCode: currencyCode, timePeriod: timePeriod)
    }

    // Overview

    public func marketGlobal(currencyCode: String) async throws -> MarketGlobal {
        try await provider.marketGlobal(currencyCode: currencyCode)
    }

    public func marketOverview(currencyCode: String) async throws -> MarketOverview {
        try await marketOverviewManager.marketOverview(currencyCode: currencyCode)
    }

    public func topMovers(currencyCode: String) async throws -> TopMovers {
        let raw = try await provider.topMoversRaw(currencyCode: currencyCode)
        return TopMovers(
            gainers100: coinManager.marketInfos(rawMarketInfos: raw.gainers100),
            gainers200: coinManager.marketInfos(rawMarketInfos: raw.gainers200),
            gainers300: coinManager.marketInfos(rawMarketInfos: raw.gainers300),
            losers100: coinManager.marketInfos(rawMarketInfos: raw.losers100),
            losers200: coinManager.marketInfos(rawMarketInfos: raw.losers200),
            losers300: coinManager.marketInfos(rawMarketInfos: raw.losers300)
        )
    }

    // NFT

    public func nftTopCollections() async throws -> [NftTopCollection] {
        try await nftManager.topCollections()
    }

    // Auth

    public func subscriptions(addresses: [String]) async throws -> [ProSubscription] {
        try await provider.subscriptions(addresses: addresses)
    }

    public func authKey(address: String) async throws -> String {
        try await provider.authKey(address: address)
    }

    public func authenticate(signature: String, address: String) async throws -> String {
        try await provider.authenticate(signature: signature, address: address)
    }

    public func requestPersonalSupport(telegramUsername: String) async throws {
        try await provider.requestPersonalSupport(telegramUsername: telegramUsername)
    }

    // Signals

    public func signals(coinUids: [String]) async throws -> [String: TechnicalAdvice.Advice] {
        let responses = try await provider.signals(coinUids: coinUids)
        return responses.reduce(into: [String: TechnicalAdvice.Advice]()) { $0[$1.uid] = $1.signal }
    }

    // Misc

    public func syncInfo() -> SyncInfo {
        coinSyncer.syncInfo()
    }

    // Stats

    public func send(stats: Any, appVersion: String, appID: String?) async throws {
        try await provider.send(stats: stats, appVersion: appVersion, appID: appID)
    }
}

extension Kit {
    public struct SyncInfo {
        public let coinsTimestamp: String?
        public let blockchainsTimestamp: String?
        public let tokensTimestamp: String?
    }

    public enum KitError: Error {
        case noChartData
        case noFullCoin
        case weakReference
    }
}

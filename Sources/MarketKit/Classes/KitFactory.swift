//
//  KitFactory.swift
//
//  Created by Sun on 2021/8/16.
//

import Foundation

import GRDB
import WWToolKit

extension Kit {
    private static let dataDirectoryName = "market-kit"
    private static let databaseFileName = "market-kit"

    public static func instance(
        apiBaseURL: String,
        cryptoCompareApiKey: String? = nil,
        providerApiKey: String? = nil,
        minLogLevel: Logger.Level = .error
    ) throws
        -> Kit {
        let logger = Logger(minLogLevel: minLogLevel)
        let reachabilityManager = ReachabilityManager()
        let networkManager = NetworkManager(logger: logger)

        let databaseURL = try dataDirectoryURL().appendingPathComponent("\(databaseFileName).sqlite")
        let dbPool = try DatabasePool(path: databaseURL.path)
        let coinStorage = try CoinStorage(dbPool: dbPool)

        let syncerStateStorage = try SyncerStateStorage(dbPool: dbPool)

        let cryptoCompareProvider = CryptoCompareProvider(networkManager: networkManager, apiKey: cryptoCompareApiKey)
        let provider = WWProvider(baseURL: apiBaseURL, networkManager: networkManager, apiKey: providerApiKey)
        let nftProvider = WWNFTProvider(
            baseURL: apiBaseURL,
            networkManager: networkManager,
            apiKey: providerApiKey
        )

        let coinManager = CoinManager(storage: coinStorage, provider: provider)
        let nftManager = NFTManager(coinManager: coinManager, provider: nftProvider)
        let marketOverviewManager = MarketOverviewManager(nftManager: nftManager, provider: provider)

        let coinSyncer = CoinSyncer(storage: coinStorage, provider: provider, syncerStateStorage: syncerStateStorage)
        let dataSyncer = WWDataSyncer(coinSyncer: coinSyncer, provider: provider)

        let coinPriceStorage = try CoinPriceStorage(dbPool: dbPool)
        let coinPriceManager = CoinPriceManager(storage: coinPriceStorage)
        let coinPriceSchedulerFactory = CoinPriceSchedulerFactory(
            manager: coinPriceManager,
            provider: provider,
            reachabilityManager: reachabilityManager,
            logger: logger
        )
        let coinPriceSyncManager = CoinPriceSyncManager(schedulerFactory: coinPriceSchedulerFactory)
        coinPriceManager.delegate = coinPriceSyncManager

        let coinHistoricalPriceStorage = try CoinHistoricalPriceStorage(dbPool: dbPool)
        let coinHistoricalPriceManager = CoinHistoricalPriceManager(
            storage: coinHistoricalPriceStorage,
            provider: provider
        )

        let postManager = PostManager(provider: cryptoCompareProvider)

        let globalMarketInfoStorage = try GlobalMarketInfoStorage(dbPool: dbPool)
        let globalMarketInfoManager = GlobalMarketInfoManager(provider: provider, storage: globalMarketInfoStorage)

        return Kit(
            coinManager: coinManager,
            nftManager: nftManager,
            marketOverviewManager: marketOverviewManager,
            dataSyncer: dataSyncer,
            coinSyncer: coinSyncer,
            coinPriceManager: coinPriceManager,
            coinPriceSyncManager: coinPriceSyncManager,
            coinHistoricalPriceManager: coinHistoricalPriceManager,
            postManager: postManager,
            globalMarketInfoManager: globalMarketInfoManager,
            provider: provider
        )
    }

    private static func dataDirectoryURL() throws -> URL {
        let fileManager = FileManager.default

        let url = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(dataDirectoryName, isDirectory: true)

        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)

        return url
    }
}

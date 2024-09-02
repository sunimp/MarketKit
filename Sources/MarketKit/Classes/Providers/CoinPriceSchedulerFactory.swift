//
//  CoinPriceSchedulerFactory.swift
//
//  Created by Sun on 2021/9/22.
//

import Foundation

import WWToolKit

class CoinPriceSchedulerFactory {
    // MARK: Properties

    private let manager: CoinPriceManager
    private let provider: WWProvider
    private let reachabilityManager: ReachabilityManager
    private var logger: Logger?

    // MARK: Lifecycle

    init(
        manager: CoinPriceManager,
        provider: WWProvider,
        reachabilityManager: ReachabilityManager,
        logger: Logger? = nil
    ) {
        self.manager = manager
        self.provider = provider
        self.reachabilityManager = reachabilityManager
        self.logger = logger
    }

    // MARK: Functions

    func scheduler(currencyCode: String, coinUidDataSource: ICoinPriceCoinUidDataSource) -> Scheduler {
        let schedulerProvider = CoinPriceSchedulerProvider(
            manager: manager,
            provider: provider,
            currencyCode: currencyCode
        )

        schedulerProvider.dataSource = coinUidDataSource

        return Scheduler(provider: schedulerProvider, reachabilityManager: reachabilityManager, logger: logger)
    }
}

//
//  CoinPriceSyncManager.swift
//  MarketKit
//
//  Created by Sun on 2021/9/22.
//

import Combine
import Foundation

// MARK: - CoinPriceKey

struct CoinPriceKey: Hashable {
    // MARK: Properties

    let coinUids: [String]
    let currencyCode: String

    // MARK: Computed Properties

    var ids: [String] {
        coinUids.sorted()
    }

    // MARK: Static Functions

    static func == (lhs: CoinPriceKey, rhs: CoinPriceKey) -> Bool {
        lhs.ids == rhs.ids && lhs.currencyCode == rhs.currencyCode
    }

    // MARK: Functions

    func hash(into hasher: inout Hasher) {
        hasher.combine(currencyCode)
        for id in ids {
            hasher.combine(id)
        }
    }
}

// MARK: - CoinPriceSyncManager

class CoinPriceSyncManager {
    // MARK: Properties

    private let queue = DispatchQueue(label: "com.sunimp.market_kit.coin_price_sync_manager", qos: .userInitiated)

    private let schedulerFactory: CoinPriceSchedulerFactory
    private var schedulers = [String: Scheduler]()
    private var subjects = [CoinPriceKey: CountedPassthroughSubject<[String: CoinPrice], Never>]()

    // MARK: Computed Properties

    private var observingCurrencies: Set<String> {
        var currencyCodes = Set<String>()
        for (existKey, _) in subjects {
            currencyCodes.insert(existKey.currencyCode)
        }
        return currencyCodes
    }

    // MARK: Lifecycle

    init(schedulerFactory: CoinPriceSchedulerFactory) {
        self.schedulerFactory = schedulerFactory
    }

    // MARK: Functions

    private func _cleanUp(key: CoinPriceKey) {
        if let subject = subjects[key], subject.subscribersCount > 0 {
            return
        }
        subjects[key] = nil

        if subjects.filter({ subjectKey, _ in subjectKey.currencyCode == key.currencyCode }).isEmpty {
            schedulers[key.currencyCode] = nil
        }
    }

    private func onDisposed(key: CoinPriceKey) {
        queue.async {
            self._cleanUp(key: key)
        }
    }

    private func observingCoinUids(currencyCode: String) -> Set<String> {
        var coinUids = Set<String>()

        for (existingKey, _) in subjects {
            if existingKey.currencyCode == currencyCode {
                coinUids.formUnion(Set(existingKey.coinUids))
            }
        }

        return coinUids
    }

    private func needForceUpdate(key: CoinPriceKey) -> Bool {
        // get set of all listening coins
        // found tokens which needed to update
        // make new key for force update

        let newCoinTypes = Set(key.coinUids).subtracting(observingCoinUids(currencyCode: key.currencyCode))
        return !newCoinTypes.isEmpty
    }

    private func _subject(key: CoinPriceKey) -> AnyPublisher<[String: CoinPrice], Never> {
        let subject: CountedPassthroughSubject<[String: CoinPrice], Never>
        var forceUpdate = false

        if let candidate = subjects[key] {
            subject = candidate
        } else { // create new subject
            forceUpdate = needForceUpdate(key: key) // if subject has non-subscribed tokens we need force schedule

            subject = CountedPassthroughSubject<[String: CoinPrice], Never>()
            subjects[key] = subject
        }

        if schedulers[key.currencyCode] == nil { // create scheduler if not exist
            let scheduler = schedulerFactory.scheduler(currencyCode: key.currencyCode, coinUidDataSource: self)
            schedulers[key.currencyCode] = scheduler
        }

        if forceUpdate { // make request for scheduler immediately
            schedulers[key.currencyCode]?.forceSchedule()
        }

        return subject
            .handleEvents(
                receiveCompletion: { [weak self] _ in self?.onDisposed(key: key) },
                receiveCancel: { [weak self] in self?.onDisposed(key: key) }
            )
            .eraseToAnyPublisher()
    }
}

// MARK: ICoinPriceCoinUidDataSource

extension CoinPriceSyncManager: ICoinPriceCoinUidDataSource {
    func allCoinUids(currencyCode: String) -> [String] {
        queue.sync {
            Array(observingCoinUids(currencyCode: currencyCode))
        }
    }

    func combinedCoinUids(currencyCode: String) -> ([String], [String]) {
        queue.sync {
            let allCoinUids = Array(observingCoinUids(currencyCode: currencyCode))
            let walletCoinUids = Array(observingCoinUids(currencyCode: currencyCode))
            return (allCoinUids, walletCoinUids)
        }
    }
}

extension CoinPriceSyncManager {
    func refresh(currencyCode: String) {
        queue.async {
            self.schedulers[currencyCode]?.forceSchedule()
        }
    }

    func coinPricePublisher(coinUid: String, currencyCode: String) -> AnyPublisher<CoinPrice, Never> {
        queue.sync {
            let coinPriceKey = CoinPriceKey(coinUids: [coinUid], currencyCode: currencyCode)

            return _subject(key: coinPriceKey)
                .flatMap { dictionary in
                    if let coinPrice = dictionary[coinUid] {
                        return Just(coinPrice).eraseToAnyPublisher()
                    }
                    return Empty().eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
    }

    func coinPriceMapPublisher(coinUids: [String], currencyCode: String) -> AnyPublisher<[String: CoinPrice], Never> {
        let key = CoinPriceKey(coinUids: coinUids, currencyCode: currencyCode)

        return queue.sync {
            _subject(key: key).eraseToAnyPublisher()
        }
    }
}

// MARK: ICoinPriceManagerDelegate

extension CoinPriceSyncManager: ICoinPriceManagerDelegate {
    func didUpdate(coinPriceMap: [String: CoinPrice], currencyCode: String) {
        queue.async {
            for (key, subject) in self.subjects {
                // send new rates for all subject which has at least one coinType in key
                if key.currencyCode == currencyCode {
                    let coinPrices = coinPriceMap.filter { coinUid, _ in
                        key.coinUids.contains(coinUid)
                    }

                    if !coinPrices.isEmpty {
                        subject.send(coinPrices)
                    }
                }
            }
        }
    }
}

// MARK: - CountedPassthroughSubject

class CountedPassthroughSubject<Output, Failure>: Subject where Failure: Error {
    // MARK: Properties

    private(set) var subscribersCount = 0

    private let subject = PassthroughSubject<Output, Failure>()

    // MARK: Functions

    func send(_ value: Output) {
        subject.send(value)
    }

    func send(completion: Subscribers.Completion<Failure>) {
        subject.send(completion: completion)
    }

    func send(subscription: Subscription) {
        subject.send(subscription: subscription)
    }

    func receive<S>(subscriber: S) where Output == S.Input, Failure == S.Failure, S: Subscriber {
        subject
            .handleEvents(
                receiveSubscription: { [weak self] _ in self?.subscribersCount += 1 },
                receiveCompletion: { [weak self] _ in self?.subscribersCount -= 1 },
                receiveCancel: { [weak self] in self?.subscribersCount -= 1 }
            )
            .receive(subscriber: subscriber)
    }
}

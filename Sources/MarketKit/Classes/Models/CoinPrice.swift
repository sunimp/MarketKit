//
//  CoinPrice.swift
//  MarketKit
//
//  Created by Sun on 2021/9/22.
//

import Foundation

import GRDB

// MARK: - CoinPrice

public class CoinPrice: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression, CaseIterable {
        case coinUid
        case currencyCode
        case value
        case diff24h
        case diff1d
        case timestamp
    }

    // MARK: Static Properties

    static let expirationInterval: TimeInterval = 240

    // MARK: Overridden Properties

    override open class var databaseTableName: String {
        "coinPrice"
    }

    // MARK: Properties

    public let coinUid: String
    public let currencyCode: String
    public let value: Decimal
    public let diff24h: Decimal?
    public let diff1d: Decimal?
    public let timestamp: TimeInterval

    // MARK: Computed Properties

    public var expired: Bool {
        Date().timeIntervalSince1970 - timestamp > Self.expirationInterval
    }

    // MARK: Lifecycle

    init(
        coinUid: String,
        currencyCode: String,
        value: Decimal,
        diff24h: Decimal?,
        diff1d: Decimal?,
        timestamp: TimeInterval
    ) {
        self.coinUid = coinUid
        self.currencyCode = currencyCode
        self.value = value
        self.diff24h = diff24h
        self.diff1d = diff1d
        self.timestamp = timestamp

        super.init()
    }

    required init(row: Row) throws {
        coinUid = row[Columns.coinUid]
        currencyCode = row[Columns.currencyCode]
        value = row[Columns.value]
        diff24h = row[Columns.diff24h]
        diff1d = row[Columns.diff1d]
        timestamp = row[Columns.timestamp]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override open func encode(to container: inout PersistenceContainer) throws {
        container[Columns.coinUid] = coinUid
        container[Columns.currencyCode] = currencyCode
        container[Columns.value] = value
        container[Columns.diff24h] = diff24h
        container[Columns.diff1d] = diff1d
        container[Columns.timestamp] = timestamp
    }
}

// MARK: CustomStringConvertible

extension CoinPrice: CustomStringConvertible {
    public var description: String {
        "CoinPrice [coinUid: \(coinUid); currencyCode: \(currencyCode); value: \(value); diff24h: \(diff24h.map { "\($0)" } ?? "nil"); timestamp: \(timestamp)]"
    }
}

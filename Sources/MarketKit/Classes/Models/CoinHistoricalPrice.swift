//
//  CoinHistoricalPrice.swift
//
//  Created by Sun on 2021/9/22.
//

import Foundation

import GRDB

// MARK: - CoinHistoricalPrice

public class CoinHistoricalPrice: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression, CaseIterable {
        case coinUid
        case currencyCode
        case value
        case timestamp
    }

    // MARK: Overridden Properties

    override open class var databaseTableName: String {
        "coinHistoricalPrice"
    }

    // MARK: Properties

    public let coinUid: String
    public let currencyCode: String
    public let value: Decimal
    public let timestamp: TimeInterval

    // MARK: Lifecycle

    init(coinUid: String, currencyCode: String, value: Decimal, timestamp: TimeInterval) {
        self.coinUid = coinUid
        self.currencyCode = currencyCode
        self.value = value
        self.timestamp = timestamp

        super.init()
    }

    required init(row: Row) throws {
        coinUid = row[Columns.coinUid]
        currencyCode = row[Columns.currencyCode]
        value = row[Columns.value]
        timestamp = row[Columns.timestamp]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override open func encode(to container: inout PersistenceContainer) throws {
        container[Columns.coinUid] = coinUid
        container[Columns.currencyCode] = currencyCode
        container[Columns.value] = value
        container[Columns.timestamp] = timestamp
    }
}

// MARK: CustomStringConvertible

extension CoinHistoricalPrice: CustomStringConvertible {
    public var description: String {
        "CoinHistoricalPrice [coinUid: \(coinUid); currencyCode: \(currencyCode); value: \(value); timestamp: \(timestamp)]"
    }
}

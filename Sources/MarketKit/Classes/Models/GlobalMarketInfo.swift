//
//  GlobalMarketInfo.swift
//  MarketKit
//
//  Created by Sun on 2021/10/13.
//

import Foundation

import GRDB
import ObjectMapper

public class GlobalMarketInfo: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case currencyCode
        case timePeriod
        case points
        case timestamp
    }

    // MARK: Overridden Properties

    override open class var databaseTableName: String {
        "globalMarketInfo"
    }

    // MARK: Properties

    public let points: [GlobalMarketPoint]

    let currencyCode: String
    let timePeriod: SWTimePeriod
    let timestamp: TimeInterval

    // MARK: Lifecycle

    init(currencyCode: String, timePeriod: SWTimePeriod, points: [GlobalMarketPoint]) {
        self.currencyCode = currencyCode
        self.timePeriod = timePeriod
        self.points = points
        timestamp = Date().timeIntervalSince1970

        super.init()
    }

    required init(row: Row) throws {
        currencyCode = row[Columns.currencyCode]
        timePeriod = SWTimePeriod(rawValue: row[Columns.timePeriod]) ?? .day1
        points = [GlobalMarketPoint](JSONString: row[Columns.points]) ?? []
        timestamp = row[Columns.timestamp]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override open func encode(to container: inout PersistenceContainer) throws {
        container[Columns.currencyCode] = currencyCode
        container[Columns.timePeriod] = timePeriod.rawValue
        container[Columns.points] = points.toJSONString()
        container[Columns.timestamp] = timestamp
    }
}

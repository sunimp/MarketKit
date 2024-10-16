//
//  SWPeriodType.swift
//  MarketKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

public enum SWPeriodType: Hashable {
    case byPeriod(SWTimePeriod)
    case byCustomPoints(SWTimePeriod, Int)
    case byStartTime(TimeInterval)

    // MARK: Static Properties

    static let keyAll = "all"

    // MARK: Computed Properties

    public var rawValue: String {
        switch self {
        case let .byPeriod(interval): interval.rawValue
        case let .byStartTime(timeStart): [Self.keyAll, Int(timeStart).description].joined(separator: "_")
        case let .byCustomPoints(interval, pointCount): [interval.rawValue, pointCount.description]
            .joined(separator: "_")
        }
    }

    // MARK: Lifecycle

    public init?(rawValue: String) {
        if let period = SWTimePeriod(rawValue: rawValue) {
            self = .byPeriod(period)
            return
        }
        let chunks = rawValue.split(separator: "_")
        if chunks.count == 2 {
            if
                chunks[0] == Self.keyAll,
                let timestamp = Int(chunks[1]) {
                self = .byStartTime(TimeInterval(timestamp))
                return
            } else if
                let period = SWTimePeriod(rawValue: String(chunks[0])),
                let pointCount = Int(chunks[1]) {
                self = .byCustomPoints(period, pointCount)
                return
            }
        }
        self = .byPeriod(.day1)
    }

    // MARK: Static Functions

    public static func == (lhs: SWPeriodType, rhs: SWPeriodType) -> Bool {
        switch (lhs, rhs) {
        case let (.byPeriod(lhsPeriod), .byPeriod(rhsPeriod)): lhsPeriod == rhsPeriod
        case let (.byStartTime(lhsStartTime), .byStartTime(rhsStartTime)): lhsStartTime == rhsStartTime
        case let (.byCustomPoints(lhsI, lhsC), .byCustomPoints(rhsI, rhsC)): lhsI == rhsI && lhsC == rhsC
        default: false
        }
    }

    // MARK: Functions

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .byPeriod(interval): hasher.combine(interval)
        case let .byStartTime(startTime): hasher.combine(startTime)
        case let .byCustomPoints(interval, pointCount):
            hasher.combine(interval)
            hasher.combine(pointCount)
        }
    }
}

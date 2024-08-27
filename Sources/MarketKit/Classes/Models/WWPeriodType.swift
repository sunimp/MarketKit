//
//  WWPeriodType.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public enum WWPeriodType: Hashable {
    static let keyAll = "all"

    case byPeriod(WWTimePeriod)
    case byCustomPoints(WWTimePeriod, Int)
    case byStartTime(TimeInterval)

    public init?(rawValue: String) {
        if let period = WWTimePeriod(rawValue: rawValue) {
            self = .byPeriod(period)
            return
        }
        let chunks = rawValue.split(separator: "_")
        if chunks.count == 2 {
            if
                chunks[0] == Self.keyAll,
                let timestamp = Int(chunks[1])
            {
                self = .byStartTime(TimeInterval(timestamp))
                return
            } else if
                let period = WWTimePeriod(rawValue: String(chunks[0])),
                let pointCount = Int(chunks[1])
            {
                self = .byCustomPoints(period, pointCount)
                return
            }
        }
        self = .byPeriod(.day1)
    }

    public var rawValue: String {
        switch self {
        case .byPeriod(let interval): interval.rawValue
        case .byStartTime(let timeStart): [Self.keyAll, Int(timeStart).description].joined(separator: "_")
        case .byCustomPoints(let interval, let pointCount): [interval.rawValue, pointCount.description].joined(separator: "_")
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .byPeriod(let interval): hasher.combine(interval)
        case .byStartTime(let startTime): hasher.combine(startTime)
        case .byCustomPoints(let interval, let pointCount):
            hasher.combine(interval)
            hasher.combine(pointCount)
        }
    }

    public static func == (lhs: WWPeriodType, rhs: WWPeriodType) -> Bool {
        switch (lhs, rhs) {
        case (.byPeriod(let lhsPeriod), .byPeriod(let rhsPeriod)): lhsPeriod == rhsPeriod
        case (.byStartTime(let lhsStartTime), .byStartTime(let rhsStartTime)): lhsStartTime == rhsStartTime
        case (.byCustomPoints(let lhsI, let lhsC), .byCustomPoints(let rhsI, let rhsC)): lhsI == rhsI && lhsC == rhsC
        default: false
        }
    }
}

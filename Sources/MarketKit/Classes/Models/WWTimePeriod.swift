//
//  WWTimePeriod.swift
//
//  Created by Sun on 2022/2/8.
//

import Foundation

// MARK: - WWTimePeriod

public enum WWTimePeriod: String, CaseIterable {
    case hour24 = "24h"
    case day1 = "1d"
    case week1 = "1w"
    case week2 = "2w"
    case month1 = "1m"
    case month3 = "3m"
    case month6 = "6m"
    case year1 = "1y"
    case year2 = "2y"
    case year5 = "5y"

    // MARK: Computed Properties

    var startTimestamp: TimeInterval {
        switch self {
        case .day1:
            .midnightUTC() + .minutes(1)
        default:
            Date().timeIntervalSince1970 - range
        }
    }

    private var range: TimeInterval {
        switch self {
        case .hour24: .days(1)
        case .day1: 0
        case .week1: .days(7)
        case .week2: .days(14)
        case .month1: .days(30)
        case .month3: .days(90)
        case .month6: .days(180)
        case .year1: .days(365)
        case .year2: 2 * .days(365)
        case .year5: 5 * .days(365)
        }
    }
}

// MARK: Comparable

extension WWTimePeriod: Comparable {
    public static func < (lhs: WWTimePeriod, rhs: WWTimePeriod) -> Bool {
        lhs.range < rhs.range
    }

    public static func == (lhs: WWTimePeriod, rhs: WWTimePeriod) -> Bool {
        lhs.range == rhs.range
    }
}

//
//  SWChartHelper.swift
//  MarketKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

public enum SWChartHelper {
    public static func validIntervals(startTime: TimeInterval?) -> [SWTimePeriod] {
        guard let startTime else {
            return SWTimePeriod.allCases
        }
        let genesisDate = Date(timeIntervalSince1970: startTime)
        let dayCount = Calendar.current.dateComponents([.day], from: genesisDate, to: Date()).day
        let monthCount = Calendar.current.dateComponents([.month], from: genesisDate, to: Date()).month
        let yearCount = Calendar.current.dateComponents([.year], from: genesisDate, to: Date()).year

        var intervals = [SWTimePeriod.day1]
        if let dayCount {
            if dayCount >= 7 {
                intervals.append(.week1)
            }
            if dayCount >= 14 {
                intervals.append(.week2)
            }
        }
        if let monthCount {
            if monthCount >= 1 {
                intervals.append(.month1)
            }
            if monthCount >= 3 {
                intervals.append(.month3)
            }
            if monthCount >= 6 {
                intervals.append(.month6)
            }
        }
        if let yearCount {
            if yearCount >= 1 {
                intervals.append(.year1)
            }
            if yearCount >= 2 {
                intervals.append(.year2)
            }
            if yearCount >= 5 {
                intervals.append(.year5)
            }
        }

        return intervals
    }

    static func pointInterval(_ interval: SWTimePeriod) -> SWPointTimePeriod {
        switch interval {
        case .day1,
             .hour24: .minute30
        case .week1: .hour4
        case .week2: .hour8
        case .month1,
             .month3,
             .month6: .day1
        case .year1,
             .year2: .week1
        case .year5: .month1
        }
    }

    static func intervalForAll(genesisTime: TimeInterval) -> SWPointTimePeriod {
        let seconds = Date().timeIntervalSince1970 - genesisTime
        if seconds <= .days(1) {
            return .minute30
        }
        if seconds <= .days(7) {
            return .hour4
        }
        if seconds <= .days(14) {
            return .hour8
        }
        if seconds <= .days(365) {
            return .day1
        }
        if seconds <= .days(5 * 365) {
            return .week1
        }
        return .month1
    }
}

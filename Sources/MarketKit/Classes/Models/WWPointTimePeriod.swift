//
//  WWPointTimePeriod.swift
//
//  Created by Sun on 2022/3/1.
//

import Foundation

public enum WWPointTimePeriod: String, CaseIterable {
    case minute30 = "30m"
    case hour1 = "1h"
    case hour4 = "4h"
    case hour8 = "8h"
    case day1 = "1d"
    case week1 = "1w"
    case month1 = "1M"

    // MARK: Computed Properties

    var interval: TimeInterval {
        switch self {
        case .minute30: .minutes(30)
        case .hour1: .hours(1)
        case .hour4: .hours(4)
        case .hour8: .hours(8)
        case .day1: .days(1)
        case .week1: .days(7)
        case .month1: .days(30)
        }
    }
}

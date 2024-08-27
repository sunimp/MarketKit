//
//  PerformanceRow.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - PerformanceRow

public struct PerformanceRow {
    public let base: PerformanceBase
    public let changes: [WWTimePeriod: Decimal]
}

// MARK: - PerformanceBase

public enum PerformanceBase: String, CaseIterable {
    case usd
    case btc
    case eth

    private var index: Int {
        switch self {
        case .usd: 0
        case .btc: 1
        case .eth: 2
        }
    }
}

// MARK: Comparable

extension PerformanceBase: Comparable {
    public static func < (lhs: PerformanceBase, rhs: PerformanceBase) -> Bool {
        lhs.index < rhs.index
    }

    public static func == (lhs: PerformanceBase, rhs: PerformanceBase) -> Bool {
        lhs.index == rhs.index
    }
}

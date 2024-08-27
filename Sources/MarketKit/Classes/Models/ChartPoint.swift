//
//  ChartPoint.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import GRDB

// MARK: - ChartPoint

public class ChartPoint {
    public let timestamp: TimeInterval
    public let value: Decimal
    public var volume: Decimal?

    public init(timestamp: TimeInterval, value: Decimal, volume: Decimal? = nil) {
        self.timestamp = timestamp
        self.value = value
        self.volume = volume
    }
}

// MARK: Equatable

extension ChartPoint: Equatable {
    public static func == (lhs: ChartPoint, rhs: ChartPoint) -> Bool {
        lhs.timestamp == rhs.timestamp && lhs.value == rhs.value && lhs.volume == rhs.volume
    }
}

// MARK: - AggregatedChartPoints

public struct AggregatedChartPoints {
    public let points: [ChartPoint]
    public let aggregatedValue: Decimal?

    public init(points: [ChartPoint], aggregatedValue: Decimal?) {
        self.points = points
        self.aggregatedValue = aggregatedValue
    }
}

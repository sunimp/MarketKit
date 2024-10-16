//
//  ChartPoint.swift
//  MarketKit
//
//  Created by Sun on 2021/9/22.
//

import Foundation

import GRDB

// MARK: - ChartPoint

public class ChartPoint {
    // MARK: Properties

    public let timestamp: TimeInterval
    public let value: Decimal
    public var volume: Decimal?

    // MARK: Lifecycle

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
    // MARK: Properties

    public let points: [ChartPoint]
    public let aggregatedValue: Decimal?

    // MARK: Lifecycle

    public init(points: [ChartPoint], aggregatedValue: Decimal?) {
        self.points = points
        self.aggregatedValue = aggregatedValue
    }
}

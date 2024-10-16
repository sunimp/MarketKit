//
//  ChartPointResponse.swift
//  MarketKit
//
//  Created by Sun on 2021/10/7.
//

import Foundation

import GRDB

public class ChartPointResponse {
    // MARK: Properties

    public let timestamp: TimeInterval
    public let value: Decimal
    public let volume: Decimal?

    // MARK: Lifecycle

    public init(timestamp: TimeInterval, value: Decimal, volume: Decimal?) {
        self.timestamp = timestamp
        self.value = value
        self.volume = volume
    }
}

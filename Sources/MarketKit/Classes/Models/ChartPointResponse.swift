//
//  ChartPointResponse.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import GRDB

public class ChartPointResponse {
    public let timestamp: TimeInterval
    public let value: Decimal
    public let volume: Decimal?

    public init(timestamp: TimeInterval, value: Decimal, volume: Decimal?) {
        self.timestamp = timestamp
        self.value = value
        self.volume = volume
    }
}

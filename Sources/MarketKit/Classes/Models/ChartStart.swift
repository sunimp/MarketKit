//
//  ChartStart.swift
//  MarketKit
//
//  Created by Sun on 2023/1/26.
//

import Foundation

import ObjectMapper

class ChartStart: ImmutableMappable {
    // MARK: Properties

    let timestamp: TimeInterval

    // MARK: Lifecycle

    init(timestamp: TimeInterval) {
        self.timestamp = timestamp
    }

    required init(map: Map) throws {
        let timestampInt: Int = try map.value("timestamp")
        timestamp = TimeInterval(timestampInt)
    }
}

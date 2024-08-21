//
//  ChartStart.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import ObjectMapper

class ChartStart: ImmutableMappable {
    let timestamp: TimeInterval

    init(timestamp: TimeInterval) {
        self.timestamp = timestamp
    }

    required init(map: Map) throws {
        let timestampInt: Int = try map.value("timestamp")
        timestamp = TimeInterval(timestampInt)
    }
}

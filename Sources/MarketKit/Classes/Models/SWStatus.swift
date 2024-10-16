//
//  SWStatus.swift
//  MarketKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import ObjectMapper

struct SWStatus: ImmutableMappable {
    // MARK: Properties

    let coins: Int
    let blockchains: Int
    let tokens: Int

    // MARK: Lifecycle

    init(map: Map) throws {
        coins = try map.value("coins")
        blockchains = try map.value("blockchains")
        tokens = try map.value("tokens")
    }
}

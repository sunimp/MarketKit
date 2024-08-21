//
//  WWStatus.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import ObjectMapper

struct WWStatus: ImmutableMappable {
    let coins: Int
    let blockchains: Int
    let tokens: Int

    init(map: Map) throws {
        coins = try map.value("coins")
        blockchains = try map.value("blockchains")
        tokens = try map.value("tokens")
    }
}

//
//  WWStatus.swift
//
//  Created by Sun on 2022/3/23.
//

import Foundation

import ObjectMapper

struct WWStatus: ImmutableMappable {
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

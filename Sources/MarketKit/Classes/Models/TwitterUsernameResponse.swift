//
//  TwitterUsernameResponse.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import ObjectMapper

public class TwitterUsernameResponse: ImmutableMappable {
    public let username: String?

    public required init(map: Map) throws {
        username = try map.value("twitter")
    }
}

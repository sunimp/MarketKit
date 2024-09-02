//
//  TwitterUsernameResponse.swift
//
//  Created by Sun on 2021/11/8.
//

import Foundation

import ObjectMapper

public class TwitterUsernameResponse: ImmutableMappable {
    // MARK: Properties

    public let username: String?

    // MARK: Lifecycle

    public required init(map: Map) throws {
        username = try map.value("twitter")
    }
}

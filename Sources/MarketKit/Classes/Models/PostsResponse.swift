//
//  PostsResponse.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import ObjectMapper

struct PostsResponse: ImmutableMappable {
    let posts: [Post]

    init(map: Map) throws {
        posts = try map.value("Data")
    }
}

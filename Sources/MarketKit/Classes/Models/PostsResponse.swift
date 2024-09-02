//
//  PostsResponse.swift
//
//  Created by Sun on 2021/9/29.
//

import Foundation

import ObjectMapper

struct PostsResponse: ImmutableMappable {
    // MARK: Properties

    let posts: [Post]

    // MARK: Lifecycle

    init(map: Map) throws {
        posts = try map.value("Data")
    }
}

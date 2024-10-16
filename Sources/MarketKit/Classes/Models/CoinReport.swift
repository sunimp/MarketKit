//
//  CoinReport.swift
//  MarketKit
//
//  Created by Sun on 2021/11/5.
//

import Foundation

import ObjectMapper

public class CoinReport: ImmutableMappable {
    // MARK: Properties

    public let author: String
    public let title: String
    public let body: String
    public let date: Date
    public let url: String

    // MARK: Lifecycle

    public required init(map: Map) throws {
        author = try map.value("author")
        title = try map.value("title")
        body = try map.value("body")
        date = try map.value("date", using: Transform.stringToDateTransform)
        url = try map.value("url")
    }
}

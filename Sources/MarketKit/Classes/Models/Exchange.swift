//
//  Exchange.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import GRDB
import ObjectMapper

// MARK: - Exchange

public class Exchange: Record, ImmutableMappable {
    public let id: String
    public let name: String
    public let imageURL: String

    override open class var databaseTableName: String {
        "exchanges"
    }

    enum Columns: String, ColumnExpression {
        case id, name, imageURL
    }

    public required init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
        imageURL = try map.value("image")

        super.init()
    }

    required init(row: Row) throws {
        id = row[Columns.id]
        name = row[Columns.name]
        imageURL = row[Columns.imageURL]

        try super.init(row: row)
    }

    override open func encode(to container: inout PersistenceContainer) throws {
        container[Columns.id] = id
        container[Columns.name] = name
        container[Columns.imageURL] = imageURL
    }
}

// MARK: CustomStringConvertible

extension Exchange: CustomStringConvertible {
    public var description: String {
        "Exchange [id: \(id); name: \(name); imageUrl: \(imageURL)]"
    }
}

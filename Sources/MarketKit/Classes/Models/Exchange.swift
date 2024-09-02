//
//  Exchange.swift
//
//  Created by Sun on 2021/10/7.
//

import Foundation

import GRDB
import ObjectMapper

// MARK: - Exchange

public class Exchange: Record, ImmutableMappable {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case id
        case name
        case imageURL
    }

    // MARK: Overridden Properties

    override open class var databaseTableName: String {
        "exchanges"
    }

    // MARK: Properties

    public let id: String
    public let name: String
    public let imageURL: String

    // MARK: Lifecycle

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

    // MARK: Overridden Functions

    override open func encode(to container: inout PersistenceContainer) throws {
        container[Columns.id] = id
        container[Columns.name] = name
        container[Columns.imageURL] = imageURL
    }
}

// MARK: CustomStringConvertible

extension Exchange: CustomStringConvertible {
    public var description: String {
        "Exchange [id: \(id); name: \(name); imageURL: \(imageURL)]"
    }
}

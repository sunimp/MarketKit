//
//  VerifiedExchange.swift
//
//  Created by Sun on 2023/11/10.
//

import Foundation

import GRDB
import ObjectMapper

class VerifiedExchange: Record, ImmutableMappable {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case uid
    }

    // MARK: Overridden Properties

    override open class var databaseTableName: String {
        "VerifiedExchange"
    }

    // MARK: Properties

    let uid: String

    // MARK: Lifecycle

    init(uid: String) {
        self.uid = uid
        super.init()
    }

    required init(map: Map) throws {
        uid = try map.value("uid")

        super.init()
    }

    required init(row: Row) throws {
        uid = row[Columns.uid]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override open func encode(to container: inout PersistenceContainer) throws {
        container[Columns.uid] = uid
    }
}

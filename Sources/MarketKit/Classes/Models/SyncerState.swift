//
//  SyncerState.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import GRDB

class SyncerState: Record {
    let key: String
    let value: String

    enum Columns: String, ColumnExpression, CaseIterable {
        case key, value
    }

    init(key: String, value: String) {
        self.key = key
        self.value = value

        super.init()
    }

    override class var databaseTableName: String {
        "syncerStates"
    }

    required init(row: Row) throws {
        key = row[Columns.key]
        value = row[Columns.value]

        try super.init(row: row)
    }

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.key] = key
        container[Columns.value] = value
    }
}

extension SyncerState: CustomStringConvertible {
    public var description: String {
        "SyncerState [key: \(key); value: \(value)]"
    }
}

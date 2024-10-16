//
//  SyncerState.swift
//  MarketKit
//
//  Created by Sun on 2021/11/15.
//

import Foundation

import GRDB

// MARK: - SyncerState

class SyncerState: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression, CaseIterable {
        case key
        case value
    }

    // MARK: Overridden Properties

    override class var databaseTableName: String {
        "syncerStates"
    }

    // MARK: Properties

    let key: String
    let value: String

    // MARK: Lifecycle

    init(key: String, value: String) {
        self.key = key
        self.value = value

        super.init()
    }

    required init(row: Row) throws {
        key = row[Columns.key]
        value = row[Columns.value]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.key] = key
        container[Columns.value] = value
    }
}

// MARK: CustomStringConvertible

extension SyncerState: CustomStringConvertible {
    public var description: String {
        "SyncerState [key: \(key); value: \(value)]"
    }
}

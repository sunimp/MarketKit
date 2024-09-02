//
//  BlockchainRecord.swift
//
//  Created by Sun on 2022/6/6.
//

import Foundation

import GRDB
import ObjectMapper

class BlockchainRecord: Record, Decodable, ImmutableMappable {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case uid
        case name
        case explorerURL = "explorerUrl"
    }

    // MARK: Static Properties

    static let tokens = hasMany(TokenRecord.self)

    // MARK: Overridden Properties

    override class var databaseTableName: String {
        "blockchain"
    }

    // MARK: Properties

    let uid: String
    let name: String
    let explorerURL: String?

    // MARK: Computed Properties

    var blockchain: Blockchain {
        Blockchain(
            type: BlockchainType(uid: uid),
            name: name,
            explorerURL: explorerURL
        )
    }

    // MARK: Lifecycle

    required init(map: Map) throws {
        uid = try map.value("uid")
        name = try map.value("name")
        explorerURL = try? map.value("url")

        super.init()
    }

    required init(row: Row) throws {
        uid = row[Columns.uid]
        name = row[Columns.name]
        explorerURL = row[Columns.explorerURL]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.uid] = uid
        container[Columns.name] = name
        container[Columns.explorerURL] = explorerURL
    }

    // MARK: Functions

    func mapping(map: Map) {
        uid >>> map["uid"]
        name >>> map["name"]
        explorerURL >>> map["url"]
    }
}

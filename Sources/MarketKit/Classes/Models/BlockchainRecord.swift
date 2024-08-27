//
//  BlockchainRecord.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import GRDB
import ObjectMapper

class BlockchainRecord: Record, Decodable, ImmutableMappable {
    static let tokens = hasMany(TokenRecord.self)

    let uid: String
    let name: String
    let explorerURL: String?

    override class var databaseTableName: String {
        "blockchain"
    }

    enum Columns: String, ColumnExpression {
        case uid, name, explorerURL
    }

    required init(map: Map) throws {
        uid = try map.value("uid")
        name = try map.value("name")
        explorerURL = try? map.value("url")

        super.init()
    }

    func mapping(map: Map) {
        uid >>> map["uid"]
        name >>> map["name"]
        explorerURL >>> map["url"]
    }

    required init(row: Row) throws {
        uid = row[Columns.uid]
        name = row[Columns.name]
        explorerURL = row[Columns.explorerURL]

        try super.init(row: row)
    }

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.uid] = uid
        container[Columns.name] = name
        container[Columns.explorerURL] = explorerURL
    }

    var blockchain: Blockchain {
        Blockchain(
            type: BlockchainType(uid: uid),
            name: name,
            explorerURL: explorerURL
        )
    }
}

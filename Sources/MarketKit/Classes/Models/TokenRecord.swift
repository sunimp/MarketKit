//
//  TokenRecord.swift
//
//  Created by Sun on 2022/6/6.
//

import Foundation

import GRDB
import ObjectMapper

class TokenRecord: Record, Decodable, ImmutableMappable {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case coinUid
        case blockchainUid
        case type
        case decimals
        case reference
    }

    // MARK: Static Properties

    static let coin = belongsTo(Coin.self)
    static let blockchain = belongsTo(BlockchainRecord.self)

    // MARK: Overridden Properties

    override class var databaseTableName: String {
        "token"
    }

    // MARK: Properties

    let coinUid: String
    let blockchainUid: String
    let type: String
    let decimals: Int?
    let reference: String?

    // MARK: Lifecycle

    init(coinUid: String, blockchainUid: String, type: String, decimals: Int? = nil, reference: String? = nil) {
        self.coinUid = coinUid
        self.blockchainUid = blockchainUid
        self.type = type
        self.decimals = decimals
        self.reference = reference

        super.init()
    }

    required init(map: Map) throws {
        let type: String = try map.value("type")

        coinUid = try map.value("coin_uid")
        blockchainUid = try map.value("blockchain_uid")
        self.type = type
        decimals = try? map.value("decimals")

        switch type {
        case "eip20": reference = try? map.value("address")
        case "bep2": reference = try? map.value("symbol")
        case "spl": reference = try? map.value("address")
        default: reference = try? map.value("address")
        }

        super.init()
    }

    required init(row: Row) throws {
        coinUid = row[Columns.coinUid]
        blockchainUid = row[Columns.blockchainUid]
        type = row[Columns.type]
        decimals = row[Columns.decimals]
        reference = row[Columns.reference]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.coinUid] = coinUid
        container[Columns.blockchainUid] = blockchainUid
        container[Columns.type] = type
        container[Columns.decimals] = decimals
        container[Columns.reference] = reference
    }

    // MARK: Functions

    func mapping(map: Map) {
        coinUid >>> map["coin_uid"]
        blockchainUid >>> map["blockchain_uid"]
        type >>> map["type"]
        decimals >>> map["decimals"]

        switch type {
        case "eip20": reference >>> map["address"]

        case "bep2": reference >>> map["symbol"]

        case "spl": reference >>> map["address"]

        case "unsupported":
            if let reference {
                reference >>> map["address"]
            }

        default: ()
        }
    }
}

//
//  Coin.swift
//  MarketKit
//
//  Created by Sun on 2021/8/16.
//

import Foundation

import GRDB
import ObjectMapper

// MARK: - Coin

public class Coin: Record, Decodable, ImmutableMappable {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case uid
        case name
        case code
        case marketCapRank
        case coinGeckoID
        case image
    }

    // MARK: Static Properties

    static let tokens = hasMany(TokenRecord.self)

    // MARK: Overridden Properties

    override open class var databaseTableName: String {
        "coin"
    }

    // MARK: Properties

    public let uid: String
    public let name: String
    public let code: String
    public let marketCapRank: Int?
    public let coinGeckoID: String?
    public let image: String?

    // MARK: Lifecycle

    public init(
        uid: String,
        name: String,
        code: String,
        marketCapRank: Int? = nil,
        coinGeckoID: String? = nil,
        image: String? = nil
    ) {
        self.uid = uid
        self.name = name
        self.code = code
        self.marketCapRank = marketCapRank
        self.coinGeckoID = coinGeckoID
        self.image = image

        super.init()
    }

    public required init(map: Map) throws {
        uid = try map.value("uid")
        name = try map.value("name")
        let code: String = try map.value("code")
        self.code = code.uppercased()
        marketCapRank = try? map.value("market_cap_rank")
        coinGeckoID = try? map.value("coingecko_id")
        image = try? map.value("image")

        super.init()
    }

    required init(row: Row) throws {
        uid = row[Columns.uid]
        name = row[Columns.name]
        code = row[Columns.code]
        marketCapRank = row[Columns.marketCapRank]
        coinGeckoID = row[Columns.coinGeckoID]
        image = row[Columns.image]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override open func encode(to container: inout PersistenceContainer) throws {
        container[Columns.uid] = uid
        container[Columns.name] = name
        container[Columns.code] = code
        container[Columns.marketCapRank] = marketCapRank
        container[Columns.coinGeckoID] = coinGeckoID
        container[Columns.image] = image
    }

    // MARK: Functions

    public func mapping(map: Map) {
        uid >>> map["uid"]
        name >>> map["name"]
        code >>> map["code"]
        marketCapRank >>> map["market_cap_rank"]
        coinGeckoID >>> map["coingecko_id"]
        image >>> map["image"]
    }
}

// MARK: Hashable

extension Coin: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}

// MARK: Equatable

extension Coin: Equatable {
    public static func == (lhs: Coin, rhs: Coin) -> Bool {
        lhs.uid == rhs.uid
    }
}

// MARK: CustomStringConvertible

extension Coin: CustomStringConvertible {
    public var description: String {
        "Coin [uid: \(uid); name: \(name); code: \(code); marketCapRank: \(marketCapRank.map { "\($0)" } ?? "nil"); coinGeckoId: \(coinGeckoID.map { "\($0)" } ?? "nil")]"
    }
}

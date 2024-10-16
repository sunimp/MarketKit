//
//  CoinTreasury.swift
//  MarketKit
//
//  Created by Sun on 2021/11/4.
//

import Foundation

import ObjectMapper

public class CoinTreasury: ImmutableMappable {
    // MARK: Nested Types

    public enum TreasuryType: String {
        case `public`
        case `private`
        case etf
    }

    // MARK: Properties

    public let type: TreasuryType
    public let fundUid: String
    public let fund: String
    public let amount: Decimal
    public let amountInCurrency: Decimal
    public let country: String

    // MARK: Lifecycle

    public required init(map: Map) throws {
        type = try map.value("type")
        fundUid = try map.value("fund_uid")
        fund = try map.value("fund")
        amount = try map.value("amount", using: Transform.stringToDecimalTransform)
        amountInCurrency = try map.value("amount_in_currency", using: Transform.stringToDecimalTransform)
        country = try map.value("country")
    }
}

//
//  CoinInvestment.swift
//
//  Created by Sun on 2021/11/3.
//

import Foundation

import ObjectMapper

public class CoinInvestment: ImmutableMappable {
    // MARK: Nested Types

    public class Fund: ImmutableMappable {
        // MARK: Properties

        public let uid: String
        public let name: String
        public let website: String
        public let isLead: Bool

        // MARK: Lifecycle

        public required init(map: Map) throws {
            uid = try map.value("uid")
            name = try map.value("name")
            website = try map.value("website")
            isLead = try map.value("is_lead")
        }
    }

    // MARK: Properties

    public let date: Date
    public let round: String
    public let amount: Decimal?
    public let funds: [Fund]

    // MARK: Lifecycle

    public required init(map: Map) throws {
        date = try map.value("date", using: Transform.stringToDateTransform)
        round = try map.value("round")
        amount = try? map.value("amount", using: Transform.stringToDecimalTransform)
        funds = try map.value("funds")
    }
}

//
//  ETFPoint.swift
//  MarketKit
//
//  Created by Sun on 2024/5/22.
//

import Foundation

import ObjectMapper

public struct ETFPoint: ImmutableMappable {
    // MARK: Properties

    public let date: Date
    public let totalAssets: Decimal
    public let totalInflow: Decimal
    public let dailyInflow: Decimal

    // MARK: Lifecycle

    public init(map: Map) throws {
        date = try map.value("date", using: ETF.dateTransform)
        totalAssets = try map.value("total_assets", using: Transform.stringToDecimalTransform)
        totalInflow = try map.value("total_inflow", using: Transform.stringToDecimalTransform)
        dailyInflow = try map.value("daily_inflow", using: Transform.stringToDecimalTransform)
    }
}

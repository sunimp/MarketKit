//
//  MarketInfo.swift
//  MarketKit
//
//  Created by Sun on 2021/9/27.
//

import Foundation

public struct MarketInfo {
    public let fullCoin: FullCoin
    public let price: Decimal?
    public let priceChange24h: Decimal?
    public let priceChange1d: Decimal?
    public let priceChange7d: Decimal?
    public let priceChange14d: Decimal?
    public let priceChange30d: Decimal?
    public let priceChange90d: Decimal?
    public let priceChange200d: Decimal?
    public let priceChange1y: Decimal?
    public let marketCap: Decimal?
    public let marketCapRank: Int?
    public let totalVolume: Decimal?
    public let athPercentage: Decimal?
    public let atlPercentage: Decimal?
    public let listedOnTopExchanges: Bool?
    public let solidCEX: Bool?
    public let solidDEX: Bool?
    public let goodDistribution: Bool?
    public let indicatorsResult: TechnicalAdvice.Advice?
}

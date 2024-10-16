//
//  TechnicalAdvice.swift
//  MarketKit
//
//  Created by Sun on 2024/3/7.
//

import Foundation

import ObjectMapper

// MARK: - TechnicalAdvice

public struct TechnicalAdvice: ImmutableMappable {
    // MARK: Properties

    public let ema: Decimal?
    public let rsi: Decimal?
    public let macd: Decimal?
    public let lower: Decimal?
    public let price: Decimal?
    public let upper: Decimal?
    public let middle: Decimal?
    public let timestamp: TimeInterval?
    public let advice: Advice?
    public let signalTimestamp: TimeInterval?

    // MARK: Lifecycle

    public init(map: Map) throws {
        ema = try? map.value("ema", using: Transform.stringToDecimalTransform)
        rsi = try? map.value("rsi", using: Transform.stringToDecimalTransform)
        macd = try? map.value("macd", using: Transform.stringToDecimalTransform)
        lower = try? map.value("lower", using: Transform.stringToDecimalTransform)
        price = try? map.value("price", using: Transform.stringToDecimalTransform)
        upper = try? map.value("upper", using: Transform.stringToDecimalTransform)
        middle = try? map.value("middle", using: Transform.stringToDecimalTransform)
        timestamp = try map.value("timestamp")
        let state: String? = try? map.value("state")
        advice = state.flatMap { Advice(rawValue: $0) }
        signalTimestamp = try? map.value("signal_timestamp")
    }
}

// MARK: TechnicalAdvice.Advice

extension TechnicalAdvice {
    public enum Advice: String, CaseIterable {
        case oversold
        case strongBuy = "buy_signal"
        case buy
        case neutral
        case sell
        case strongSell = "sell_signal"
        case overbought

        // MARK: Computed Properties

        public var isRisky: Bool {
            switch self {
            case .oversold,
                 .overbought: true
            default: false
            }
        }
    }
}

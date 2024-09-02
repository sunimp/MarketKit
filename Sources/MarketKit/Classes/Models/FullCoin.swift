//
//  FullCoin.swift
//
//  Created by Sun on 2021/9/24.
//

import Foundation

public struct FullCoin {
    // MARK: Properties

    public let coin: Coin
    public let tokens: [Token]

    // MARK: Lifecycle

    public init(coin: Coin, tokens: [Token]) {
        self.coin = coin
        self.tokens = tokens
    }
}

//
//  Singleton.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import MarketKit

class Singleton {
    static let shared = Singleton()

    let kit: Kit

    init() {
        kit = try! Kit.instance(
            hsApiBaseURL: "https://api-dev.blocksdecoded.com",
            minLogLevel: .error
        )

        kit.sync()
    }
}

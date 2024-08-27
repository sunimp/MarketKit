//
//  TokenType.swift
//  MarketKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - TokenType

public enum TokenType {
    public enum Derivation: String, CaseIterable {
        case bip44
        case bip49
        case bip84
        case bip86
    }

    public enum AddressType: String, CaseIterable {
        case type0
        case type145
    }

    case native
    case derived(derivation: Derivation)
    case addressType(type: AddressType)
    case eip20(address: String)
    case bep2(symbol: String)
    case spl(address: String)
    case unsupported(type: String, reference: String?)

    public init(type: String, reference: String? = nil) {
        let chunks = type.split(separator: ":").map { String($0) }

        if chunks.count == 1 {
            switch chunks[0] {
            case "native":
                self = .native
                return

            case "eip20":
                if let reference {
                    self = .eip20(address: reference)
                    return
                }

            case "bep2":
                if let reference {
                    self = .bep2(symbol: reference)
                    return
                }

            case "spl":
                if let reference {
                    self = .spl(address: reference)
                    return
                }

            default: ()
            }
        } else if chunks.count == 2 {
            switch chunks[0] {
            case "derived":
                if let derivation = Derivation(rawValue: chunks[1]) {
                    self = .derived(derivation: derivation)
                    return
                }

            case "address_type":
                if let addressType = AddressType(rawValue: chunks[1]) {
                    self = .addressType(type: addressType)
                    return
                }

            default: ()
            }
        }

        self = .unsupported(type: type, reference: reference)
    }

    public init?(id: String) {
        let chunks = id.split(separator: ":").map { String($0) }

        switch chunks.count {
        case 1:
            switch chunks[0] {
            case "native": self = .native
            default: return nil
            }

        case 2:
            switch chunks[0] {
            case "derived":
                guard let derivation = Derivation(rawValue: chunks[1]) else {
                    return nil
                }
                self = .derived(derivation: derivation)

            case "address_type":
                guard let type = AddressType(rawValue: chunks[1]) else {
                    return nil
                }
                self = .addressType(type: type)

            case "eip20": self = .eip20(address: chunks[1])

            case "bep2": self = .bep2(symbol: chunks[1])

            case "spl": self = .spl(address: chunks[1])

            case "unsupported": self = .unsupported(type: chunks[1], reference: nil)

            default: return nil
            }

        case 3:
            switch chunks[0] {
            case "unsupported": self = .unsupported(type: chunks[1], reference: chunks[2])
            default: return nil
            }

        default:
            return nil
        }
    }

    public var id: String {
        switch self {
        case .native:
            "native"
        case .derived(let derivation):
            ["derived", derivation.rawValue].joined(separator: ":")
        case .addressType(let type):
            ["address_type", type.rawValue].joined(separator: ":")
        case .eip20(let address):
            ["eip20", address].joined(separator: ":")
        case .bep2(let symbol):
            ["bep2", symbol].joined(separator: ":")
        case .spl(let address):
            ["spl", address].joined(separator: ":")
        case .unsupported(let type, let reference):
            if let reference {
                ["unsupported", type, reference].joined(separator: ":")
            } else {
                ["unsupported", type].joined(separator: ":")
            }
        }
    }

    public var values: (type: String, reference: String?) {
        switch self {
        case .native: (type: "native", reference: nil)
        case .derived(let derivation): (type: "derived:\(derivation.rawValue)", reference: nil)
        case .addressType(let type): (type: "address_type:\(type.rawValue)", reference: nil)
        case .eip20(let address): (type: "eip20", reference: address)
        case .bep2(let symbol): (type: "bep2", reference: symbol)
        case .spl(let address): (type: "spl", reference: address)
        case .unsupported(let type, let reference): (type: type, reference: reference)
        }
    }
}

// MARK: Equatable

extension TokenType: Equatable {
    public static func == (lhs: TokenType, rhs: TokenType) -> Bool {
        let (lhsType, lhsReference) = lhs.values
        let (rhsType, rhsReference) = rhs.values

        return lhsType == rhsType && lhsReference == rhsReference
    }
}

// MARK: Hashable

extension TokenType: Hashable {
    public func hash(into hasher: inout Hasher) {
        let (type, reference) = values

        hasher.combine(type)
        hasher.combine(reference)
    }
}

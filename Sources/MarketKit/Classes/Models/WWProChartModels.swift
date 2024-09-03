//
//  WWProChartModels.swift
//
//  Created by Sun on 2022/5/6.
//

import Foundation

import ObjectMapper

// MARK: - Analytics

public struct Analytics: ImmutableMappable {
    // MARK: Nested Types

    public struct ExVolume: ImmutableMappable {
        // MARK: Properties

        public let points: [VolumePoint]
        public let rank30d: Int?
        public let rating: String?

        // MARK: Computed Properties

        public var aggregatedChartPoints: AggregatedChartPoints {
            AggregatedChartPoints(
                points: points.map(\.chartPoint),
                aggregatedValue: points.map(\.volume).reduce(0, +)
            )
        }

        // MARK: Lifecycle

        public init(map: Map) throws {
            points = try map.value("points")
            rank30d = try? map.value("rank_30d")
            rating = try? map.value("rating")
        }
    }

    public struct DEXLiquidity: ImmutableMappable {
        // MARK: Properties

        public let points: [VolumePoint]
        public let rank: Int?
        public let rating: String?

        // MARK: Computed Properties

        public var chartPoints: [ChartPoint] {
            points.map(\.chartPoint)
        }

        // MARK: Lifecycle

        public init(map: Map) throws {
            points = try map.value("points")
            rank = try? map.value("rank")
            rating = try? map.value("rating")
        }
    }

    public struct Addresses: ImmutableMappable {
        // MARK: Properties

        public let points: [CountPoint]
        public let rank30d: Int?
        public let count30d: Int?
        public let rating: String?

        // MARK: Computed Properties

        public var chartPoints: [ChartPoint] {
            points.map(\.chartPoint)
        }

        // MARK: Lifecycle

        public init(map: Map) throws {
            points = try map.value("points")
            rank30d = try? map.value("rank_30d")
            count30d = try? map.value("count_30d")
            rating = try? map.value("rating")
        }
    }

    public struct Transactions: ImmutableMappable {
        // MARK: Properties

        public let points: [CountPoint]
        public let rank30d: Int?
        public let volume30d: Decimal?
        public let rating: String?

        // MARK: Computed Properties

        public var aggregatedChartPoints: AggregatedChartPoints {
            AggregatedChartPoints(
                points: points.map(\.chartPoint),
                aggregatedValue: points.map(\.count).reduce(0, +)
            )
        }

        // MARK: Lifecycle

        public init(map: Map) throws {
            points = try map.value("points")
            rank30d = try? map.value("rank_30d")
            volume30d = try? map.value("volume_30d", using: Transform.stringToDecimalTransform)
            rating = try? map.value("rating")
        }
    }

    public struct HolderBlockchain: ImmutableMappable {
        // MARK: Properties

        public let uid: String
        public let holdersCount: Decimal

        // MARK: Lifecycle

        public init(map: Map) throws {
            uid = try map.value("blockchain_uid")
            holdersCount = try map.value("holders_count", using: Transform.stringToDecimalTransform)
        }
    }

    public struct Tvl: ImmutableMappable {
        // MARK: Properties

        public let points: [TvlPoint]
        public let rank: Int?
        public let ratio: Decimal?
        public let rating: String?

        // MARK: Computed Properties

        public var chartPoints: [ChartPoint] {
            points.map(\.chartPoint)
        }

        // MARK: Lifecycle

        public init(map: Map) throws {
            points = try map.value("points")
            rank = try? map.value("rank")
            ratio = try? map.value("ratio", using: Transform.stringToDecimalTransform)
            rating = try? map.value("rating")
        }
    }

    public struct ValueRank: ImmutableMappable {
        // MARK: Properties

        public let value30d: Decimal?
        public let rank30d: Int?
        public let description: String?

        // MARK: Lifecycle

        public init(map: Map) throws {
            value30d = try? map.value("value_30d", using: Transform.stringToDecimalTransform)
            rank30d = try? map.value("rank_30d")
            description = try? map.value("description")
        }
    }

    public struct TvlPoint: ImmutableMappable {
        // MARK: Properties

        public let timestamp: TimeInterval
        public let tvl: Decimal

        // MARK: Computed Properties

        public var chartPoint: ChartPoint {
            ChartPoint(timestamp: timestamp, value: tvl)
        }

        // MARK: Lifecycle

        public init(map: Map) throws {
            timestamp = try map.value("timestamp")
            tvl = try map.value("tvl", using: Transform.stringToDecimalTransform)
        }
    }

    public struct IssueBlockchain: ImmutableMappable {
        // MARK: Properties

        public let blockchain: String
        public let issues: [Issue]

        // MARK: Lifecycle

        public init(map: Map) throws {
            blockchain = try map.value("blockchain")
            issues = try map.value("issues")
        }
    }

    public struct Issue: ImmutableMappable {
        // MARK: Nested Types

        public struct Issue: ImmutableMappable {
            // MARK: Properties

            public let impact: String?
            public let description: String?

            // MARK: Lifecycle

            public init(map: Map) throws {
                impact = try map.value("impact")
                description = try? map.value("description")
            }
        }

        // MARK: Properties

        public let issue: String?
        public let title: String?
        public let description: String?
        public let issues: [Issue]?

        // MARK: Lifecycle

        public init(map: Map) throws {
            issue = try? map.value("issue")
            title = try? map.value("title")
            description = try? map.value("description")
            issues = try? map.value("issues")
        }
    }

    public struct Audit: ImmutableMappable {
        // MARK: Properties

        public let name: String
        public let date: String
        public let techIssues: Int?
        public let auditURL: String?
        public let partnerName: String?

        // MARK: Lifecycle

        public init(map: Map) throws {
            name = try map.value("name")
            date = try map.value("date")
            techIssues = try? map.value("tech_issues")
            auditURL = try? map.value("audit_url")
            partnerName = try? map.value("partner_name")
        }
    }

    // MARK: Properties

    public let cexVolume: ExVolume?
    public let dexVolume: ExVolume?
    public let dexLiquidity: DEXLiquidity?
    public let addresses: Addresses?
    public let transactions: Transactions?
    public let holders: [HolderBlockchain]?
    public let holdersRank: Int?
    public let holdersRating: String?
    public let tvl: Tvl?
    public let fee: ValueRank?
    public let revenue: ValueRank?
    public let reports: Int?
    public let fundsInvested: Decimal?
    public let treasuries: Decimal?
    public let issueBlockchains: [IssueBlockchain]?
    public let technicalAdvice: TechnicalAdvice?
    public let audits: [Audit]?

    // MARK: Lifecycle

    public init(map: Map) throws {
        cexVolume = try? map.value("cex_volume")
        dexVolume = try? map.value("dex_volume")
        dexLiquidity = try? map.value("dex_liquidity")
        addresses = try? map.value("addresses")
        transactions = try? map.value("transactions")
        holders = try? map.value("holders")
        holdersRank = try? map.value("holders_rank")
        holdersRating = try? map.value("holders_rating")
        tvl = try? map.value("tvl")
        fee = try? map.value("fee")
        revenue = try? map.value("revenue")
        reports = try? map.value("reports")
        fundsInvested = try? map.value("funds_invested", using: Transform.stringToDecimalTransform)
        treasuries = try? map.value("treasuries", using: Transform.stringToDecimalTransform)
        issueBlockchains = try? map.value("issues")
        technicalAdvice = try? map.value("indicators")
        audits = try? map.value("audits")
    }
}

// MARK: - AnalyticsPreview

public struct AnalyticsPreview: ImmutableMappable {
    // MARK: Properties

    public let cexVolume: Bool
    public let cexVolumeRank30d: Bool
    public let cexVolumeRating: Bool
    public let dexVolume: Bool
    public let dexVolumeRank30d: Bool
    public let dexVolumeRating: Bool
    public let dexLiquidity: Bool
    public let dexLiquidityRank: Bool
    public let dexLiquidityRating: Bool
    public let addresses: Bool
    public let addressesCount30d: Bool
    public let addressesRank30d: Bool
    public let addressesRating: Bool
    public let transactions: Bool
    public let transactionsVolume30d: Bool
    public let transactionsRank30d: Bool
    public let transactionsRating: Bool
    public let holders: Bool
    public let holdersRank: Bool
    public let holdersRating: Bool
    public let tvl: Bool
    public let tvlRank: Bool
    public let tvlRatio: Bool
    public let tvlRating: Bool
    public let fee: Bool
    public let feeRank30d: Bool
    public let revenue: Bool
    public let revenueRank30d: Bool
    public let reports: Bool
    public let fundsInvested: Bool
    public let treasuries: Bool

    // MARK: Lifecycle

    public init(map: Map) throws {
        cexVolume = (try? map.value("cex_volume.points")) ?? false
        cexVolumeRank30d = (try? map.value("cex_volume.rank_30d")) ?? false
        cexVolumeRating = (try? map.value("cex_volume.rating")) ?? false
        dexVolume = (try? map.value("dex_volume.points")) ?? false
        dexVolumeRank30d = (try? map.value("dex_volume.rank_30d")) ?? false
        dexVolumeRating = (try? map.value("dex_volume.rating")) ?? false
        dexLiquidity = (try? map.value("dex_liquidity.points")) ?? false
        dexLiquidityRank = (try? map.value("dex_liquidity.rank")) ?? false
        dexLiquidityRating = (try? map.value("dex_liquidity.rating")) ?? false
        addresses = (try? map.value("addresses.points")) ?? false
        addressesRank30d = (try? map.value("addresses.rank_30d")) ?? false
        addressesCount30d = (try? map.value("addresses.count_30d")) ?? false
        addressesRating = (try? map.value("addresses.rating")) ?? false
        transactions = (try? map.value("transactions.points")) ?? false
        transactionsVolume30d = (try? map.value("transactions.volume_30d")) ?? false
        transactionsRank30d = (try? map.value("transactions.rank_30d")) ?? false
        transactionsRating = (try? map.value("transactions.rating")) ?? false
        holders = (try? map.value("holders")) ?? false
        holdersRank = (try? map.value("holders_rank")) ?? false
        holdersRating = (try? map.value("holders_rating")) ?? false
        tvl = (try? map.value("tvl.points")) ?? false
        tvlRank = (try? map.value("tvl.rank")) ?? false
        tvlRatio = (try? map.value("tvl.ratio")) ?? false
        tvlRating = (try? map.value("tvl.rating")) ?? false
        fee = (try? map.value("fee.value_30d")) ?? false
        feeRank30d = (try? map.value("fee.rank_30d")) ?? false
        revenue = (try? map.value("revenue.value_30d")) ?? false
        revenueRank30d = (try? map.value("revenue.rank_30d")) ?? false
        reports = (try? map.value("reports")) ?? false
        fundsInvested = (try? map.value("funds_invested")) ?? false
        treasuries = (try? map.value("treasuries")) ?? false
    }
}

// MARK: - VolumePoint

public struct VolumePoint: ImmutableMappable {
    // MARK: Properties

    public let timestamp: TimeInterval
    public let volume: Decimal

    // MARK: Computed Properties

    public var chartPoint: ChartPoint {
        ChartPoint(timestamp: timestamp, value: volume)
    }

    // MARK: Lifecycle

    public init(map: Map) throws {
        timestamp = try map.value("timestamp")
        volume = try map.value("volume", using: Transform.stringToDecimalTransform)
    }
}

// MARK: - CountPoint

public struct CountPoint: ImmutableMappable {
    // MARK: Properties

    public let timestamp: TimeInterval
    public let count: Decimal

    // MARK: Computed Properties

    public var chartPoint: ChartPoint {
        ChartPoint(timestamp: timestamp, value: count)
    }

    // MARK: Lifecycle

    public init(map: Map) throws {
        timestamp = try map.value("timestamp")
        count = try map.value("count", using: Transform.stringToDecimalTransform)
    }
}

// MARK: - CountVolumePoint

public struct CountVolumePoint: ImmutableMappable {
    // MARK: Properties

    public let timestamp: TimeInterval
    public let count: Decimal
    public let volume: Decimal

    // MARK: Computed Properties

    public var chartPoint: ChartPoint {
        ChartPoint(timestamp: timestamp, value: count, volume: volume)
    }

    // MARK: Lifecycle

    public init(map: Map) throws {
        timestamp = try map.value("timestamp")
        count = try map.value("count", using: Transform.stringToDecimalTransform)
        volume = try map.value("volume", using: Transform.stringToDecimalTransform)
    }
}

// MARK: - RankMultiValue

public struct RankMultiValue: ImmutableMappable {
    // MARK: Properties

    public let uid: String
    public let value1d: Decimal?
    public let value7d: Decimal?
    public let value30d: Decimal?

    // MARK: Lifecycle

    public init(map: Map) throws {
        uid = try map.value("uid")
        value1d = try? map.value("value_1d", using: Transform.stringToDecimalTransform)
        value7d = try? map.value("value_7d", using: Transform.stringToDecimalTransform)
        value30d = try? map.value("value_30d", using: Transform.stringToDecimalTransform)
    }
}

// MARK: - RankValue

public struct RankValue: ImmutableMappable {
    // MARK: Properties

    public let uid: String
    public let value: Decimal?

    // MARK: Lifecycle

    public init(map: Map) throws {
        uid = try map.value("uid")
        value = try? map.value("value", using: Transform.stringToDecimalTransform)
    }
}

// MARK: - ProSubscription

public struct ProSubscription: ImmutableMappable {
    // MARK: Properties

    public let address: String
    public let deadline: TimeInterval

    // MARK: Lifecycle

    public init(map: Map) throws {
        address = try map.value("address")
        deadline = try map.value("deadline")
    }
}

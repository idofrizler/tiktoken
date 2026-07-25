import Foundation

enum MockCreditMath {
    static let fiveHourTokenLimit = 500_000

    static func clampedPercent(_ percent: Double) -> Double {
        min(max(percent, 0), 100)
    }

    static func remainingTokens(for percent: Double) -> Int {
        Int((clampedPercent(percent) / 100 * Double(fiveHourTokenLimit)).rounded())
    }

    static func fillForAlien(at index: Int, percent: Double) -> Double {
        let alienShare = clampedPercent(percent) / 20
        return min(max(alienShare - Double(index), 0), 1)
    }

    static func compactTokenText(for percent: Double) -> String {
        remainingTokens(for: percent).formatted(
            .number.notation(.compactName).precision(.fractionLength(0...1))
        )
    }
}

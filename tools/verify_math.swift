import Foundation

@main
struct MathVerifier {
    static func main() {
        precondition(MockCreditMath.remainingTokens(for: 80) == 800_000)
        precondition(MockCreditMath.remainingTokens(for: -10) == 0)
        precondition(MockCreditMath.remainingTokens(for: 120) == 1_000_000)

        let thirtyPercent = (0..<5).map {
            MockCreditMath.fillForAlien(at: $0, percent: 30)
        }
        precondition(thirtyPercent == [1, 0.5, 0, 0, 0])

        let eightyPercent = (0..<5).map {
            MockCreditMath.fillForAlien(at: $0, percent: 80)
        }
        precondition(eightyPercent == [1, 1, 1, 1, 0])

        print("Mock credit calculations passed")
    }
}

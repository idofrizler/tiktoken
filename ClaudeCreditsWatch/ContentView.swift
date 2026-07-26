import SwiftUI

struct ContentView: View {
    @AppStorage("remainingPercent") private var remainingPercent = 68.0
    @AppStorage("mockResetAt") private var mockResetAt = 0.0
    @AppStorage("mockScenarioVersion") private var mockScenarioVersion = 0
    @State private var isShowingControls = false
    @FocusState private var receivesCrownInput: Bool

    private var resetDate: Date {
        Date(timeIntervalSince1970: mockResetAt)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            FiveAliensFaceView(
                remainingPercent: remainingPercent,
                resetDate: resetDate
            )
        }
        .contentShape(Rectangle())
        .focusable()
        .focused($receivesCrownInput)
#if os(watchOS)
        .digitalCrownRotation(
            $remainingPercent,
            from: 0,
            through: 100,
            by: 1,
            sensitivity: .medium,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        ._statusBarHidden()
#endif
        .onAppear {
            remainingPercent = MockCreditMath.clampedPercent(remainingPercent)
            if mockScenarioVersion < 1 {
                remainingPercent = 68
                mockResetAt = Date.now.addingTimeInterval((2 * 60 + 43) * 60).timeIntervalSince1970
                mockScenarioVersion = 1
            } else if resetDate <= .now {
                mockResetAt = Date.now.addingTimeInterval((2 * 60 + 43) * 60).timeIntervalSince1970
            }
            receivesCrownInput = true
        }
        .onChange(of: remainingPercent) { _, newValue in
            remainingPercent = MockCreditMath.clampedPercent(newValue)
        }
        .onLongPressGesture(minimumDuration: 0.55) {
            isShowingControls = true
        }
        .sheet(isPresented: $isShowingControls, onDismiss: {
            receivesCrownInput = true
        }) {
            MockControlsView(
                remainingPercent: $remainingPercent,
                resetAt: $mockResetAt
            )
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Claude credits prototype")
        .accessibilityValue("\(Int(remainingPercent.rounded())) percent remaining")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

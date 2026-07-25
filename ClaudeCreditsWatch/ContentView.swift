import SwiftUI

enum FaceStyle: String, CaseIterable, Identifiable {
    case fiveAliens
    case analogDrain

    var id: String { rawValue }

    var title: String {
        switch self {
        case .fiveAliens:
            return "Five aliens"
        case .analogDrain:
            return "Analog drain"
        }
    }
}

struct ContentView: View {
    @AppStorage("remainingPercent") private var remainingPercent = 68.0
    @AppStorage("mockResetAt") private var mockResetAt = 0.0
    @AppStorage("mockScenarioVersion") private var mockScenarioVersion = 0
    @AppStorage("selectedFace") private var selectedFaceRawValue = FaceStyle.fiveAliens.rawValue
    @State private var isShowingControls = false
    @FocusState private var receivesCrownInput: Bool

    private var selectedFace: FaceStyle {
        get { FaceStyle(rawValue: selectedFaceRawValue) ?? .fiveAliens }
        nonmutating set { selectedFaceRawValue = newValue.rawValue }
    }

    private var resetDate: Date {
        Date(timeIntervalSince1970: mockResetAt)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch selectedFace {
            case .fiveAliens:
                FiveAliensFaceView(
                    remainingPercent: remainingPercent,
                    resetDate: resetDate
                )
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
            case .analogDrain:
                AnalogDrainFaceView(
                    remainingPercent: remainingPercent,
                    resetDate: resetDate
                )
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
            }
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
                resetAt: $mockResetAt,
                selectedFaceRawValue: $selectedFaceRawValue
            )
        }
        .overlay(alignment: .topLeading) {
            Button(action: toggleFace) {
                HStack(spacing: 5) {
                    ForEach(FaceStyle.allCases) { style in
                        Circle()
                            .fill(
                                style == selectedFace
                                    ? Color.creditOrange
                                    : Color.white.opacity(0.24)
                            )
                            .frame(width: 5, height: 5)
                    }
                }
                .frame(width: 64, height: 44)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Switch watch design")
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Claude credits prototype")
        .accessibilityValue("\(Int(remainingPercent.rounded())) percent remaining")
    }

    private func toggleFace() {
        withAnimation(.easeInOut(duration: 0.22)) {
            selectedFace = selectedFace == .fiveAliens ? .analogDrain : .fiveAliens
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

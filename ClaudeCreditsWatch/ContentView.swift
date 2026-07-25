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
    @AppStorage("selectedFace") private var selectedFaceRawValue = FaceStyle.fiveAliens.rawValue
    @State private var isShowingControls = false
    @FocusState private var receivesCrownInput: Bool

    private var selectedFace: FaceStyle {
        get { FaceStyle(rawValue: selectedFaceRawValue) ?? .fiveAliens }
        nonmutating set { selectedFaceRawValue = newValue.rawValue }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch selectedFace {
            case .fiveAliens:
                FiveAliensFaceView(remainingPercent: remainingPercent)
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
            case .analogDrain:
                AnalogDrainFaceView(remainingPercent: remainingPercent)
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
            receivesCrownInput = true
        }
        .onChange(of: remainingPercent) { _, newValue in
            remainingPercent = MockCreditMath.clampedPercent(newValue)
        }
        .onTapGesture(count: 2) {
            withAnimation(.easeInOut(duration: 0.22)) {
                selectedFace = selectedFace == .fiveAliens ? .analogDrain : .fiveAliens
            }
        }
        .onLongPressGesture(minimumDuration: 0.55) {
            isShowingControls = true
        }
        .sheet(isPresented: $isShowingControls, onDismiss: {
            receivesCrownInput = true
        }) {
            MockControlsView(
                remainingPercent: $remainingPercent,
                selectedFaceRawValue: $selectedFaceRawValue
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

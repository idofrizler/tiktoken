import SwiftUI

struct MockControlsView: View {
    @Binding var remainingPercent: Double
    @Binding var resetAt: Double
    @Binding var selectedFaceRawValue: String
    @Environment(\.dismiss) private var dismiss

    private var selectedFace: Binding<FaceStyle> {
        Binding(
            get: { FaceStyle(rawValue: selectedFaceRawValue) ?? .fiveAliens },
            set: { selectedFaceRawValue = $0.rawValue }
        )
    }

    private var resetDate: Date {
        Date(timeIntervalSince1970: resetAt)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Design") {
                    Picker("Face", selection: selectedFace) {
                        ForEach(FaceStyle.allCases) { style in
                            Text(style.title).tag(style)
                        }
                    }
                }

                Section("Mock 5-hour allowance") {
                    VStack(spacing: 8) {
                        Text("\(Int(remainingPercent.rounded()))%")
                            .font(.title2.bold())
                            .foregroundStyle(Color.creditOrange)

                        Text("\(MockCreditMath.compactTokenText(for: remainingPercent)) tokens remaining")
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        Slider(value: $remainingPercent, in: 0...100, step: 1)
                            .tint(Color.creditOrange)
                    }

                    Button("20%") { remainingPercent = 20 }
                    Button("50%") { remainingPercent = 50 }
                    Button("80%") { remainingPercent = 80 }
                    Button("Full") { remainingPercent = 100 }
                }

                Section("Reset time") {
                    Text(resetDate, style: .timer)
                        .font(.title3.monospacedDigit())
                        .foregroundStyle(Color.creditOrange)

                    Button("Reset in 1 hour") {
                        setReset(after: 1)
                    }
                    Button("Reset in 3 hours") {
                        setReset(after: 3)
                    }
                    Button("Reset in 5 hours") {
                        setReset(after: 5)
                    }
                }

                Section("Shortcuts") {
                    Text("Crown adjusts credits")
                    Text("Tap the top-left dots to switch face")
                    Text("Tap digital time for countdown")
                    Text("Long-press opens this panel")
                }
                .font(.footnote)
            }
            .navigationTitle("Prototype")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func setReset(after hours: Double) {
        resetAt = Date.now.addingTimeInterval(hours * 60 * 60).timeIntervalSince1970
    }
}

struct MockControlsView_Previews: PreviewProvider {
    static var previews: some View {
        MockControlsView(
            remainingPercent: .constant(68),
            resetAt: .constant(Date.now.addingTimeInterval(3 * 60 * 60).timeIntervalSince1970),
            selectedFaceRawValue: .constant(FaceStyle.fiveAliens.rawValue)
        )
    }
}

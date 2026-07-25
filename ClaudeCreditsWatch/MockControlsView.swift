import SwiftUI

struct MockControlsView: View {
    @Binding var remainingPercent: Double
    @Binding var selectedFaceRawValue: String
    @Environment(\.dismiss) private var dismiss

    private var selectedFace: Binding<FaceStyle> {
        Binding(
            get: { FaceStyle(rawValue: selectedFaceRawValue) ?? .fiveAliens },
            set: { selectedFaceRawValue = $0.rawValue }
        )
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

                Section("Mock credits") {
                    VStack(spacing: 8) {
                        Text("\(Int(remainingPercent.rounded()))%")
                            .font(.title2.bold())
                            .foregroundStyle(Color.creditOrange)

                        Text("\(MockCreditMath.compactTokenText(for: remainingPercent)) tokens left")
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

                Section("Shortcuts") {
                    Text("Crown adjusts credits")
                    Text("Double-tap switches face")
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
}

struct MockControlsView_Previews: PreviewProvider {
    static var previews: some View {
        MockControlsView(
            remainingPercent: .constant(68),
            selectedFaceRawValue: .constant(FaceStyle.fiveAliens.rawValue)
        )
    }
}

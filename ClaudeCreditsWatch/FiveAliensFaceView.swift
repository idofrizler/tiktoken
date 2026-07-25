import Foundation
import SwiftUI

struct FiveAliensFaceView: View {
    let remainingPercent: Double

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.periodic(from: .now, by: 1)) { context in
                VStack(spacing: 0) {
                    Spacer(minLength: geometry.size.height * 0.055)

                    Text(context.date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                        .font(.system(size: geometry.size.height * 0.047, weight: .semibold, design: .rounded))
                        .textCase(.uppercase)
                        .tracking(1)
                        .foregroundStyle(Color.white.opacity(0.55))

                    Spacer(minLength: geometry.size.height * 0.035)

                    HStack(alignment: .lastTextBaseline, spacing: 6) {
                        Text(context.date, format: .dateTime.hour().minute())
                            .font(.system(size: geometry.size.height * 0.215, weight: .light, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.white)
                            .tracking(-2)

                        Text(String(format: "%02d", Calendar.current.component(.second, from: context.date)))
                            .font(.system(size: geometry.size.height * 0.057, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(Color.creditOrange)
                            .padding(.bottom, geometry.size.height * 0.017)
                    }

                    Spacer()

                    VStack(spacing: geometry.size.height * 0.022) {
                        HStack(alignment: .firstTextBaseline, spacing: 5) {
                            Text("\(Int(remainingPercent.rounded()))%")
                                .font(.system(size: geometry.size.height * 0.085, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .foregroundStyle(Color.creditOrange)

                            Text("\(MockCreditMath.compactTokenText(for: remainingPercent)) left")
                                .font(.system(size: geometry.size.height * 0.043, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.white.opacity(0.52))
                        }

                        HStack(spacing: geometry.size.width * 0.018) {
                            ForEach(0..<5, id: \.self) { index in
                                PixelAlienMeter(
                                    fraction: MockCreditMath.fillForAlien(
                                        at: index,
                                        percent: remainingPercent
                                    )
                                )
                            }
                        }
                        .frame(height: geometry.size.height * 0.105)
                    }
                    .padding(.horizontal, geometry.size.width * 0.055)
                    .padding(.bottom, geometry.size.height * 0.045)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(
            RadialGradient(
                colors: [Color.creditOrange.opacity(0.07), .black],
                center: .bottom,
                startRadius: 2,
                endRadius: 180
            )
        )
    }
}

struct FiveAliensFaceView_Previews: PreviewProvider {
    static var previews: some View {
        FiveAliensFaceView(remainingPercent: 70)
    }
}

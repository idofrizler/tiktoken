import Foundation
import SwiftUI

struct FiveAliensFaceView: View {
    let remainingPercent: Double
    let resetDate: Date
    @State private var showsResetCountdown = false

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

                    timeDisplay(
                        now: context.date,
                        height: geometry.size.height
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showsResetCountdown.toggle()
                        }
                    }

                    Spacer()

                    VStack(spacing: geometry.size.height * 0.022) {
                        HStack(alignment: .firstTextBaseline, spacing: 5) {
                            Text("\(Int(remainingPercent.rounded()))%")
                                .font(.system(size: geometry.size.height * 0.085, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .foregroundStyle(Color.creditOrange)

                            Text(MockCreditMath.compactTokenText(for: remainingPercent))
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

    @ViewBuilder
    private func timeDisplay(now: Date, height: CGFloat) -> some View {
        if showsResetCountdown {
            VStack(spacing: height * 0.006) {
                Text("RESET IN")
                    .font(.system(size: height * 0.04, weight: .semibold, design: .rounded))
                    .tracking(1.4)
                    .foregroundStyle(Color.creditOrange)

                Text(countdownText(from: now))
                    .font(.system(size: height * 0.155, weight: .light, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.7)
            }
            .transition(.opacity.combined(with: .scale(scale: 0.96)))
        } else {
            HStack(alignment: .lastTextBaseline, spacing: 6) {
                Text(now, format: .dateTime.hour().minute())
                    .font(.system(size: height * 0.215, weight: .light, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .tracking(-2)

                Text(String(format: "%02d", Calendar.current.component(.second, from: now)))
                    .font(.system(size: height * 0.057, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Color.creditOrange)
                    .padding(.bottom, height * 0.017)
            }
            .transition(.opacity.combined(with: .scale(scale: 0.96)))
        }
    }

    private func countdownText(from now: Date) -> String {
        let remainingSeconds = max(Int(resetDate.timeIntervalSince(now)), 0)
        let hours = remainingSeconds / 3_600
        let minutes = remainingSeconds % 3_600 / 60
        let seconds = remainingSeconds % 60
        return String(format: "%01d:%02d:%02d", hours, minutes, seconds)
    }
}

struct FiveAliensFaceView_Previews: PreviewProvider {
    static var previews: some View {
        FiveAliensFaceView(
            remainingPercent: 70,
            resetDate: .now.addingTimeInterval(2.5 * 60 * 60)
        )
    }
}

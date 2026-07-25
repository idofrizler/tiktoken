import SwiftUI

struct AnalogDrainFaceView: View {
    let remainingPercent: Double
    let resetDate: Date

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let diameter = min(geometry.size.width, geometry.size.height)
                let radius = diameter * 0.49
                let angles = ClockAngles(date: context.date)
                let resetAngle = ClockAngles(date: resetDate).hour

                ZStack {
                    RadialGradient(
                        colors: [Color.white.opacity(0.045), .black],
                        center: .center,
                        startRadius: 4,
                        endRadius: radius
                    )

                    ForEach(0..<60, id: \.self) { tick in
                        Capsule()
                            .fill(tick.isMultiple(of: 5) ? Color.white.opacity(0.62) : Color.clockTick)
                            .frame(
                                width: tick.isMultiple(of: 5) ? 2.2 : 1,
                                height: tick.isMultiple(of: 5) ? diameter * 0.045 : diameter * 0.018
                            )
                            .offset(y: -radius + diameter * 0.028)
                            .rotationEffect(.degrees(Double(tick) * 6))
                    }

                    resetMarker(
                        diameter: diameter,
                        radius: radius,
                        angle: resetAngle
                    )

                    PixelAlienMeter(
                        fraction: remainingPercent / 100,
                        direction: .vertical,
                        activeColor: Color.creditOrange.opacity(0.9),
                        inactiveColor: Color.white.opacity(0.12)
                    )
                    .frame(width: diameter * 0.62, height: diameter * 0.50)
                    .offset(y: diameter * 0.025)

                    clockHand(
                        length: diameter * 0.27,
                        width: 4,
                        color: .white,
                        angle: angles.hour
                    )

                    clockHand(
                        length: diameter * 0.38,
                        width: 2.4,
                        color: .white,
                        angle: angles.minute
                    )

                    clockHand(
                        length: diameter * 0.43,
                        width: 1,
                        color: .creditOrange,
                        angle: angles.second
                    )

                    Circle()
                        .fill(Color.creditOrange)
                        .frame(width: 8, height: 8)
                        .overlay(Circle().stroke(Color.black.opacity(0.5), lineWidth: 1))

                    VStack {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("\(Int(remainingPercent.rounded()))%")
                                .font(.system(size: diameter * 0.095, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.creditOrange)

                            Text("5H")
                                .font(.system(size: diameter * 0.05, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.white.opacity(0.55))
                        }
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.72), in: Capsule())
                        .padding(.top, diameter * 0.12)

                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private func resetMarker(
        diameter: CGFloat,
        radius: CGFloat,
        angle: Double
    ) -> some View {
        VStack(spacing: 2) {
            Circle()
                .fill(Color.creditOrange)
                .frame(width: diameter * 0.028, height: diameter * 0.028)

            Capsule()
                .fill(Color.creditOrange)
                .frame(width: 2.5, height: diameter * 0.055)
        }
        .offset(y: -radius + diameter * 0.018)
        .rotationEffect(.degrees(angle))
        .shadow(color: Color.creditOrange.opacity(0.55), radius: 3)
        .accessibilityLabel("Five hour allowance resets at \(resetDate.formatted(date: .omitted, time: .shortened))")
    }

    private func clockHand(
        length: CGFloat,
        width: CGFloat,
        color: Color,
        angle: Double
    ) -> some View {
        Capsule()
            .fill(color)
            .frame(width: width, height: length)
            .offset(y: -length / 2)
            .rotationEffect(.degrees(angle))
            .shadow(color: .black.opacity(0.55), radius: 1, x: 0, y: 1)
    }
}

private struct ClockAngles {
    let hour: Double
    let minute: Double
    let second: Double

    init(date: Date, calendar: Calendar = .current) {
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        let hourValue = Double(components.hour ?? 0)
        let minuteValue = Double(components.minute ?? 0)
        let secondValue = Double(components.second ?? 0)

        hour = hourValue.truncatingRemainder(dividingBy: 12) * 30 + minuteValue * 0.5
        minute = minuteValue * 6 + secondValue * 0.1
        second = secondValue * 6
    }
}

struct AnalogDrainFaceView_Previews: PreviewProvider {
    static var previews: some View {
        AnalogDrainFaceView(
            remainingPercent: 42,
            resetDate: .now.addingTimeInterval(2.5 * 60 * 60)
        )
    }
}

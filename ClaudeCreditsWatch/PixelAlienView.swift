import SwiftUI

enum AlienFillDirection {
    case horizontal
    case vertical
}

struct PixelAlienMeter: View {
    let fraction: Double
    var direction: AlienFillDirection = .horizontal
    var activeColor: Color = .creditOrange
    var inactiveColor: Color = .depletedAlien

    private var clampedFraction: Double {
        min(max(fraction, 0), 1)
    }

    var body: some View {
        ZStack {
            PixelAlienGlyph(color: inactiveColor)

            PixelAlienGlyph(color: activeColor)
                .mask {
                    GeometryReader { geometry in
                        switch direction {
                        case .horizontal:
                            Rectangle()
                                .frame(width: geometry.size.width * clampedFraction)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        case .vertical:
                            Rectangle()
                                .frame(height: geometry.size.height * clampedFraction)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                        }
                    }
                }
                .shadow(color: activeColor.opacity(0.32), radius: 4)
        }
        .aspectRatio(12 / 8, contentMode: .fit)
    }
}

struct PixelAlienGlyph: View {
    let color: Color

    // Pose 1 from the user's clawd-invaders mascot, normalized to a 12x8 grid.
    private let pixels: [[Int]] = [
        [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [0, 0, 1, 2, 1, 1, 1, 1, 2, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0]
    ]

    var body: some View {
        Canvas { context, size in
            let cellSize = min(size.width / 12, size.height / 8)
            let drawingSize = CGSize(width: cellSize * 12, height: cellSize * 8)
            let origin = CGPoint(
                x: (size.width - drawingSize.width) / 2,
                y: (size.height - drawingSize.height) / 2
            )
            var bodyPath = Path()
            var eyePath = Path()

            for row in pixels.indices {
                for column in pixels[row].indices where pixels[row][column] != 0 {
                    let rect = CGRect(
                        x: origin.x + CGFloat(column) * cellSize,
                        y: origin.y + CGFloat(row) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )
                    if pixels[row][column] == 2 {
                        eyePath.addRect(rect)
                    } else {
                        bodyPath.addRect(rect)
                    }
                }
            }

            context.fill(bodyPath, with: .color(color))
            context.fill(eyePath, with: .color(Color.black.opacity(0.9)))
        }
        .aspectRatio(12 / 8, contentMode: .fit)
        .accessibilityHidden(true)
    }
}

struct PixelAlienView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            PixelAlienMeter(fraction: 0.5)
            PixelAlienMeter(fraction: 0.7, direction: .vertical)
        }
        .padding()
        .background(Color.black)
    }
}

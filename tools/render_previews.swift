import AppKit
import SwiftUI

@main
struct PreviewRenderer {
    @MainActor
    static func main() throws {
        let outputDirectory = URL(fileURLWithPath: "Previews", isDirectory: true)
        try FileManager.default.createDirectory(
            at: outputDirectory,
            withIntermediateDirectories: true
        )

        try render(
            FiveAliensFaceView(remainingPercent: 70),
            size: CGSize(width: 198, height: 242),
            to: outputDirectory.appendingPathComponent("five-aliens-70.png")
        )

        try render(
            AnalogDrainFaceView(remainingPercent: 42),
            size: CGSize(width: 198, height: 242),
            to: outputDirectory.appendingPathComponent("analog-drain-42.png")
        )
    }

    @MainActor
    private static func render<Content: View>(
        _ content: Content,
        size: CGSize,
        to outputURL: URL
    ) throws {
        let renderer = ImageRenderer(
            content: content
                .frame(width: size.width, height: size.height)
                .background(Color.black)
        )
        renderer.scale = 3

        guard
            let image = renderer.nsImage,
            let tiff = image.tiffRepresentation,
            let bitmap = NSBitmapImageRep(data: tiff),
            let png = bitmap.representation(using: .png, properties: [:])
        else {
            throw RenderError.failed(outputURL.lastPathComponent)
        }

        try png.write(to: outputURL)
        print("Wrote \(outputURL.path)")
    }
}

private enum RenderError: Error {
    case failed(String)
}

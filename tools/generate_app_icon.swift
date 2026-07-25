import AppKit

let size = 1024
let image = NSImage(size: NSSize(width: size, height: size))

image.lockFocus()

let background = NSGradient(
    starting: NSColor(calibratedRed: 0.08, green: 0.075, blue: 0.07, alpha: 1),
    ending: NSColor(calibratedRed: 0.015, green: 0.015, blue: 0.018, alpha: 1)
)!
background.draw(in: NSRect(x: 0, y: 0, width: size, height: size), angle: -90)

let pixels = [
    "001111111100",
    "001211112100",
    "111111111111",
    "111111111111",
    "001111111100",
    "001111111100",
    "001010010100",
    "001010010100"
]

let cell = 62
let alienWidth = cell * 12
let alienHeight = cell * 8
let originX = (size - alienWidth) / 2
let originY = (size - alienHeight) / 2 - 8
let orange = NSColor(calibratedRed: 218 / 255, green: 119 / 255, blue: 86 / 255, alpha: 1)

NSGraphicsContext.current?.cgContext.setShadow(
    offset: .zero,
    blur: 48,
    color: orange.withAlphaComponent(0.42).cgColor
)

for (row, line) in pixels.enumerated() {
    for (column, character) in line.enumerated() where character != "0" {
        let rect = NSRect(
            x: originX + column * cell,
            y: size - originY - (row + 1) * cell,
            width: cell,
            height: cell
        )
        (character == "2" ? NSColor.black : orange).setFill()
        rect.fill()
    }
}

image.unlockFocus()

guard
    let tiff = image.tiffRepresentation,
    let bitmap = NSBitmapImageRep(data: tiff),
    let png = bitmap.representation(using: .png, properties: [:])
else {
    fatalError("Could not render app icon")
}

let outputURL = URL(
    fileURLWithPath: "ClaudeCreditsWatch/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"
)
try png.write(to: outputURL)
print("Wrote \(outputURL.path)")

# Agent Guide

## Project

Credit Aliens is a standalone SwiftUI watchOS app that visualizes a mocked
Claude five-hour allowance. It is intentionally a watch-only app; there is no
iOS companion target and Apple does not permit third-party system watch faces.

The two in-app designs are:

- `FiveAliensFaceView`: digital clock/countdown with five horizontally filled
  Clawd sprites.
- `AnalogDrainFaceView`: analog dial with one vertically drained Clawd and a
  reset-time marker.

## Important behavior

- The Digital Crown changes the mocked remaining percentage.
- The two dots at the top center switch designs. Keep them above all face
  elements and preserve their large invisible hit target.
- Tapping the digital clock toggles the reset countdown.
- Clock and countdown content share a fixed-height frame so the date does not
  move.
- Long-pressing opens `MockControlsView`.
- Default mock state is 68% of a 500K token-equivalent allowance with 2h43m
  until reset.

## Source map

- `ClaudeCreditsWatch/ContentView.swift`: persisted mock state, face selection,
  crown input, controls sheet, and selector dots.
- `ClaudeCreditsWatch/FiveAliensFaceView.swift`: digital design and countdown.
- `ClaudeCreditsWatch/AnalogDrainFaceView.swift`: analog design and reset mark.
- `ClaudeCreditsWatch/PixelAlienView.swift`: exact 12x8 Clawd sprite and partial
  fill rendering.
- `ClaudeCreditsWatch/MockCreditMath.swift`: percentage, token-equivalent, and
  five-segment calculations.
- `project.yml`: XcodeGen source of truth for target settings.
- `ClaudeCreditsWatch.xcodeproj`: committed so a fresh clone opens without
  requiring XcodeGen.
- `docs/DEPLOYMENT.md`: simulator and physical-device handoff.

## Development rules

- Keep the watch target standalone with `WKApplication = true` and
  `WKWatchOnly = true`.
- Do not add `WKRunsIndependentlyOfCompanionApp` alongside `WKWatchOnly`.
- Do not put Claude credentials, session tokens, or API keys in the app or
  repository.
- Preserve the combined-path sprite rendering; separate translucent pixel
  cells create visible grid seams.
- The private `._statusBarHidden()` modifier is acceptable for this personal
  sideloaded prototype but must be reconsidered before App Store distribution.
- When changing target settings or file membership, update `project.yml`, run
  `xcodegen generate`, and commit the regenerated Xcode project.
- When changing visible UI, update relevant screenshots under `Previews/`.

## Validation

Build for a simulator:

```sh
xcodebuild \
  -project ClaudeCreditsWatch.xcodeproj \
  -scheme ClaudeCreditsWatch \
  -sdk watchsimulator \
  -destination 'generic/platform=watchOS Simulator' \
  -derivedDataPath .build \
  CODE_SIGNING_ALLOWED=NO \
  build
```

Run the calculation checks:

```sh
swiftc -parse-as-library \
  ClaudeCreditsWatch/MockCreditMath.swift \
  tools/verify_math.swift \
  -o /tmp/credit-aliens-verify
/tmp/credit-aliens-verify
rm /tmp/credit-aliens-verify
```

## Future live integration

Claude Code status-line JSON can expose
`rate_limits.five_hour.used_percentage` and
`rate_limits.five_hour.resets_at`. A future implementation should send only
sanitized usage data through a local bridge, iCloud, or an authenticated HTTPS
relay. Authentication material must remain off the Watch.

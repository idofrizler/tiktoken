# Install and deploy

The repository includes a committed Xcode project, so another Mac can clone and
open it without installing XcodeGen.

## Requirements

- A Mac with a full Xcode installation and a watchOS platform compatible with
  the target device.
- For a simulator: a watchOS simulator runtime installed from **Xcode >
  Settings > Components**.
- For a physical install: an iPhone paired with an Apple Watch, a USB or
  trusted wireless connection from the iPhone to the Mac, and an Apple ID added
  under **Xcode > Settings > Accounts**.

The app's deployment target is watchOS 10.0.

## Clone and run in a simulator

```sh
git clone https://github.com/idofrizler/tiktoken.git
cd tiktoken
open ClaudeCreditsWatch.xcodeproj
```

In Xcode:

1. Select the `ClaudeCreditsWatch` scheme.
2. Choose an Apple Watch simulator.
3. Press **Run**.

## Install on another person's Apple Watch

This is a watch-only app. Xcode installs it on the Apple Watch paired with the
iPhone; it does not install an iPhone home-screen app.

1. Pair the Apple Watch with the iPhone and finish any pending OS updates.
2. Connect the unlocked iPhone to the Mac and accept all trust prompts.
3. Open **Window > Devices and Simulators** in Xcode and let it discover and
   prepare both devices.
4. Enable **Developer Mode** under **Settings > Privacy & Security** on the
   iPhone and Apple Watch, then restart them when prompted. If the option is not
   visible on the Watch yet, keep the paired iPhone connected to Xcode until it
   appears.
5. Select the `ClaudeCreditsWatch` target, open **Signing & Capabilities**, keep
   automatic signing enabled, and select the developer's team.
6. Replace `com.idofrizler.ClaudeCreditsWatch` with a unique reverse-DNS bundle
   identifier owned by that team, such as
   `com.yourname.ClaudeCreditsWatch`.
7. Choose the paired Apple Watch run destination, usually shown with its paired
   iPhone, and press **Run**.
8. Launch **Credit Aliens** from the Watch app library.

If `project.yml` is regenerated on that Mac, make the same bundle identifier
change there first or XcodeGen will restore the committed identifier.

A free Apple Personal Team can sideload for testing, but its provisioning
normally expires after seven days. A paid Apple Developer membership provides
longer-lived development provisioning.

## Troubleshooting

- **Bundle identifier cannot be registered:** choose a new unique identifier
  under **Signing & Capabilities**.
- **Watch destination is unavailable:** unlock both devices, verify Developer
  Mode, keep Bluetooth and Wi-Fi enabled, reconnect the iPhone, and allow Xcode
  to finish preparing device support.
- **watchOS platform is missing:** install it from Xcode's Components settings.
- **App is not listed as a face:** expected. Apple does not allow this custom UI
  to become a native system watch face; open it as an app.

## Regenerating the project

The checked-in project is generated from `project.yml`. Regeneration is only
needed after changing target settings or project structure:

```sh
brew install xcodegen
xcodegen generate
```

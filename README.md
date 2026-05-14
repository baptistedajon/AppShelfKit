# AppShelfKit

AppShelfKit is a lightweight SwiftUI package for Apple platform developers who want to showcase and cross-promote their other apps inside their apps.

This repository contains the early AppShelfKit foundation: app metadata models, SwiftUI shelf views, layout and style customization, and JSON configuration loading.

## Requirements

- iOS 17+
- iPadOS 17+
- macOS 14+
- visionOS 1+
- Swift Package Manager

## Installation

Add AppShelfKit to your project with Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/<owner>/AppShelfKit.git", from: "0.1.0")
]
```

Replace `<owner>` with the GitHub account or organization that hosts the repository, then add the `AppShelfKit` product to your app target.

## JSON Configuration

You can define an app shelf in a bundled `apps.json` file:

```json
{
  "title": "More Apps",
  "subtitle": "Apps from the same developer",
  "apps": [
    {
      "id": "daybook",
      "name": "Daybook",
      "subtitle": "Private daily notes",
      "description": "A calm place for daily writing and reflection.",
      "iconURL": "https://example.com/daybook.png",
      "appStoreURL": "https://apps.apple.com/app/daybook/id123456789",
      "category": "Lifestyle",
      "tintColorHex": "#2F80ED",
      "isFeatured": true
    },
    {
      "id": "focus-timer",
      "name": "Focus Timer",
      "subtitle": "Simple sessions for deep work",
      "iconURL": "https://example.com/focus-timer.png",
      "appStoreURL": "https://apps.apple.com/app/focus-timer/id234567890",
      "category": "Productivity",
      "isFeatured": false
    }
  ]
}
```

Decode it from a bundle resource:

```swift
let configuration = try AppShelfConfiguration.decodeResource(named: "apps")

AppShelfView(
    apps: configuration.apps,
    layout: .featured,
    style: .prominent
)
```

Remote JSON loading is optional. If you host the same JSON shape yourself, load it with `AppShelfLoader`:

```swift
let loader = AppShelfLoader()
let configuration = try await loader.load(from: remoteConfigurationURL)
```

For a one-line SwiftUI integration that handles loading and error states:

```swift
AppShelfRemoteView(
    configurationURL: remoteConfigurationURL,
    layout: .featured,
    style: .prominent
)
```

You can build App Store links from numeric app IDs when constructing items in code:

```swift
let item = AppShelfItem(
    name: "Daybook",
    appStoreID: "123456789"
)

let url = AppStoreAppIdentifier("123456789").appStoreURL
```

## Package Structure

```text
Sources/AppShelfKit/
  Configuration/
  Models/
  Styles/
  Views/
Tests/AppShelfKitTests/
```

## Example App

Open `Examples/AppShelfKitExample/AppShelfKitExample.xcworkspace` in Xcode to run the sample SwiftUI app. The workspace includes both the example app project and the local AppShelfKit package, which helps Xcode resolve the `AppShelfKit` product reliably. The sample demonstrates hardcoded apps, bundled JSON configuration, layout variants, style presets, and remote configuration placeholder code.

## Project Resources

- `AGENTS.md`: guardrails for AI coding agents.
- `CONTRIBUTING.md`: contribution workflow and public API expectations.
- `CHANGELOG.md`: release notes and roadmap.
- `RELEASE_CHECKLIST.md`: release process.
- `llms.txt`: AI-readable project map.

## License

AppShelfKit is available under the MIT license. See `LICENSE` for details.

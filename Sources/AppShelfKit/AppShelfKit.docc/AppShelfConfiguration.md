# ``AppShelfConfiguration``

Decode app shelf content from JSON.

## Overview

``AppShelfConfiguration`` is a `Codable` model for JSON-backed shelves. It contains optional heading text and an array of ``AppShelfItem`` values.

```json
{
  "title": "More Apps",
  "subtitle": "Apps from the same developer",
  "apps": [
    {
      "id": "daybook",
      "name": "Daybook",
      "subtitle": "Private daily notes",
      "appStoreURL": "https://apps.apple.com/app/id123456789",
      "isFeatured": true
    }
  ]
}
```

Decode JSON data directly:

```swift
let configuration = try AppShelfConfiguration.decode(from: data)
```

Or decode a bundled resource named `apps.json`:

```swift
let configuration = try AppShelfConfiguration.decodeResource(named: "apps")

AppShelfView(
    apps: configuration.apps,
    layout: .featured,
    style: .prominent
)
```

## Errors

Configuration decoding throws ``AppShelfConfigurationError`` for missing resources, unreadable resources, and invalid JSON.

## Topics

### Creating Configuration

- ``init(title:subtitle:apps:)``
- ``title``
- ``subtitle``
- ``apps``

### Decoding

- ``decode(from:decoder:)``
- ``decodeResource(named:withExtension:in:decoder:)``
- ``AppShelfConfigurationError``

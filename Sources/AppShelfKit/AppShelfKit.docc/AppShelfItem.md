# ``AppShelfItem``

Describe an app that can be shown in an AppShelfKit shelf.

## Overview

``AppShelfItem`` is a small value type containing the metadata needed to render an app in ``AppShelfView``.

```swift
let item = AppShelfItem(
    id: "daybook",
    name: "Daybook",
    subtitle: "Private daily notes",
    description: "A calm place for daily writing.",
    iconURL: URL(string: "https://example.com/daybook.png"),
    appStoreID: "123456789",
    category: "Lifestyle",
    tintColorHex: "#2F80ED",
    isFeatured: true
)
```

Use the `appStoreURL` initializer when you already have a full URL. Use the `appStoreID` initializer when you only have the numeric App Store ID.

```swift
let item = AppShelfItem(
    name: "Focus Timer",
    appStoreID: "234567890"
)
```

``AppShelfItem`` conforms to `Identifiable`, `Hashable`, `Codable`, and `Sendable`, so it can be used in SwiftUI collections, JSON configuration files, tests, and concurrent loading flows.

## Topics

### Creating Items

- ``init(id:name:subtitle:description:iconURL:appStoreURL:category:tintColorHex:isFeatured:)``
- ``init(id:name:subtitle:description:iconURL:appStoreID:category:tintColorHex:isFeatured:)``

### App Metadata

- ``id``
- ``name``
- ``subtitle``
- ``description``
- ``iconURL``
- ``appStoreURL``
- ``category``
- ``tintColorHex``
- ``isFeatured``

### App Store IDs

- ``AppStoreAppIdentifier``

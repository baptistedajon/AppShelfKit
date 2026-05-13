# AppShelfKit Overview

Showcase and cross-promote your other apps inside SwiftUI apps.

## Overview

AppShelfKit is a lightweight SwiftUI package for Apple platform developers who want to present a polished shelf of related apps. It supports hardcoded app data, bundled JSON configuration, optional remote JSON loading, multiple layouts, and simple style presets.

Use AppShelfKit when you want to add an "Other Apps", "More from this developer", settings, about, or cross-promotion section without building custom list and grid UI from scratch.

```swift
import AppShelfKit
import SwiftUI

struct MoreAppsView: View {
    let apps = [
        AppShelfItem(
            name: "Daybook",
            subtitle: "Private daily notes",
            appStoreID: "123456789",
            isFeatured: true
        ),
        AppShelfItem(
            name: "Focus Timer",
            subtitle: "Simple sessions for deep work",
            appStoreID: "234567890"
        ),
    ]

    var body: some View {
        AppShelfView(
            apps: apps,
            layout: .featured,
            style: .prominent
        )
    }
}
```

### Choose a Data Source

For small shelves, create ``AppShelfItem`` values directly in code. For shelves you want to update without changing Swift source, decode an ``AppShelfConfiguration`` from bundled JSON. For shelves hosted on your own server, use ``AppShelfLoader`` or the one-line ``AppShelfRemoteView``.

### Choose a Layout

``AppShelfLayout`` includes list, card, compact, and featured presentations. Each layout works with Dynamic Type and uses native SwiftUI controls.

### Choose a Style

``AppShelfStyle`` controls whether descriptions, categories, and open buttons are shown, as well as spacing, icon size, and corner radius. Start with a preset such as ``AppShelfStyle/automatic`` or ``AppShelfStyle/prominent``.

## Topics

### Essentials

- ``AppShelfView``
- ``AppShelfRemoteView``
- ``AppShelfItem``
- ``AppStoreAppIdentifier``

### Configuration

- ``AppShelfConfiguration``
- ``AppShelfConfigurationError``
- ``AppShelfLoader``
- ``AppShelfLoadingError``

### Presentation

- ``AppShelfLayout``
- ``AppShelfStyle``

### Tutorials

- <doc:ShowcaseAppsWithHardcodedData>
- <doc:LoadAppsFromLocalJSON>
- <doc:LoadAppsFromRemoteJSON>
- <doc:CustomizeLayoutAndStyle>

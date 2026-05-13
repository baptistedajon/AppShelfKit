# ``AppShelfView``

Display a collection of apps with a native SwiftUI shelf.

## Overview

``AppShelfView`` is the primary view in AppShelfKit. It accepts an array of ``AppShelfItem`` values and renders them using an ``AppShelfLayout`` and ``AppShelfStyle``.

```swift
AppShelfView(
    apps: apps,
    layout: .list,
    style: .automatic
)
```

Each item opens its ``AppShelfItem/appStoreURL`` with SwiftUI's `openURL` environment action. The view includes accessible button labels, Dynamic Type support, remote icon loading through `AsyncImage`, and native placeholders for missing icons.

## Choosing a Layout

Use ``AppShelfLayout/list`` for full rows, ``AppShelfLayout/cards`` for grid presentation, ``AppShelfLayout/compact`` for settings or about screens, and ``AppShelfLayout/featured`` when one item should stand out.

```swift
AppShelfView(
    apps: apps,
    layout: .cards,
    style: .minimal
)
```

## Styling

Use ``AppShelfStyle`` presets or create a custom style.

```swift
let style = AppShelfStyle(
    showsDescriptions: true,
    showsCategories: true,
    showsOpenButton: true,
    cornerRadius: 16,
    spacing: 14,
    iconSize: 56
)

AppShelfView(apps: apps, layout: .featured, style: style)
```

## Topics

### Creating a Shelf

- ``init(apps:layout:style:)``
- ``apps``
- ``layout``
- ``style``

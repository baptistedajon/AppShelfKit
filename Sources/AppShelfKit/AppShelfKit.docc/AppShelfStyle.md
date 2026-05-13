# ``AppShelfStyle``

Customize spacing, icon size, surfaces, and optional shelf details.

## Overview

``AppShelfStyle`` controls the visual density and content shown by ``AppShelfView``. Styles are plain values, so you can use a preset or create a custom style for your app.

```swift
AppShelfView(
    apps: apps,
    layout: .cards,
    style: .minimal
)
```

For a richer shelf, show descriptions and categories:

```swift
AppShelfView(
    apps: apps,
    layout: .featured,
    style: .prominent
)
```

## Custom Styles

```swift
let customStyle = AppShelfStyle(
    showsDescriptions: true,
    showsCategories: true,
    showsOpenButton: true,
    cornerRadius: 18,
    spacing: 16,
    iconSize: 52
)
```

## Topics

### Presets

- ``automatic``
- ``minimal``
- ``prominent``
- ``compact``

### Creating Styles

- ``init(showsDescriptions:showsCategories:showsOpenButton:cornerRadius:spacing:iconSize:)``

### Options

- ``showsDescriptions``
- ``showsCategories``
- ``showsOpenButton``
- ``cornerRadius``
- ``spacing``
- ``iconSize``

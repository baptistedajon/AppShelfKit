# ``AppShelfLayout``

Choose how AppShelfKit presents app items.

## Overview

``AppShelfLayout`` defines the major presentation variants supported by ``AppShelfView`` and ``AppShelfRemoteView``.

```swift
AppShelfView(apps: apps, layout: .list)
AppShelfView(apps: apps, layout: .cards)
AppShelfView(apps: apps, layout: .compact)
AppShelfView(apps: apps, layout: .featured)
```

Each layout is native SwiftUI and supports Dynamic Type.

## Layouts

- ``list``: Full vertical rows for common "More Apps" sections.
- ``cards``: An adaptive grid for visual browsing.
- ``compact``: Smaller rows for settings and about screens.
- ``featured``: A larger featured app followed by compact secondary apps.

## Topics

### Cases

- ``list``
- ``cards``
- ``compact``
- ``featured``

# ``AppShelfRemoteView``

Load a remote JSON configuration and display it as an app shelf.

## Overview

``AppShelfRemoteView`` is the one-line integration for remote app shelves. It accepts a configuration URL, loads the remote JSON with ``AppShelfLoader``, and displays the resulting apps with ``AppShelfView``.

```swift
AppShelfRemoteView(
    configurationURL: URL(string: "https://example.com/apps.json")!,
    layout: .featured,
    style: .prominent
)
```

The view has native loading, success, and error states. It uses `.task(id:)` internally, so loading starts automatically when the view appears or when the URL changes.

## Error State

If loading fails, ``AppShelfRemoteView`` shows a small friendly fallback instead of crashing or requiring extra app-side state.

For more control over retries, caching, or custom error UI, use ``AppShelfLoader`` directly and pass loaded apps to ``AppShelfView``.

## Topics

### Creating a Remote Shelf

- ``init(configurationURL:layout:style:)``
- ``configurationURL``
- ``layout``
- ``style``

# Changelog

All notable changes to AppShelfKit will be documented in this file.

AppShelfKit follows semantic versioning. Versions below 1.0 should be considered early and may still evolve based on developer feedback.

## 0.1.0 - 2026-05-13

First public release of AppShelfKit, a lightweight SwiftUI package for indie Apple developers who want to showcase and cross-promote their other apps inside their apps.

### Current Features

- Swift Package Manager library product named `AppShelfKit`.
- Platform support for iOS 17+, iPadOS 17+, macOS 14+, and visionOS 1+.
- `AppShelfItem` model for app metadata, including names, subtitles, descriptions, icon URLs, App Store URLs, categories, tint color metadata, and featured state.
- `AppStoreAppIdentifier` helper for building App Store URLs from numeric app IDs.
- Native SwiftUI `AppShelfView` with list, cards, compact, and featured layouts.
- `AppShelfStyle` presets for automatic, minimal, prominent, and compact presentation.
- Async remote icon loading with native `AsyncImage` and polished placeholders.
- Accessibility defaults for rows, buttons, decorative imagery, and Dynamic Type.
- Bundled JSON configuration support through `AppShelfConfiguration`.
- Optional remote JSON loading through `AppShelfLoader`.
- One-line remote SwiftUI integration with `AppShelfRemoteView`.
- Deterministic unit tests for models, configuration decoding, style presets, layout cases, App Store URL generation, and mocked remote loading.
- DocC documentation and tutorials suitable for Swift Package Index.
- Sample SwiftUI app demonstrating local data, bundled JSON, layout variants, style presets, and remote loading placeholder code.

### Known Limitations

- Remote loading does not include built-in caching, retry policies, or offline persistence.
- JSON configuration is intentionally simple and does not support versioned schemas or localization metadata yet.
- Icon loading relies on `AsyncImage`; advanced image caching and custom image pipelines are not included.
- App Store metadata is not fetched automatically. Developers provide all app names, descriptions, icons, and links.
- Styling is preset-based with a small set of public controls rather than a full theming system.
- Layouts are optimized for simple app shelves, not large catalogs or search-heavy app directories.

### Roadmap

- Add optional local caching for remote configurations.
- Add richer style hooks while keeping the default API small.
- Add localization guidance and examples for JSON-backed shelves.
- Add more sample configurations and integration examples.
- Explore optional analytics hooks for app shelf impressions and taps.
- Continue improving accessibility coverage and Swift Package Index documentation.

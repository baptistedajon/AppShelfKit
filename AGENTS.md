# AGENTS.md

Guidance for AI coding agents working on AppShelfKit.

AppShelfKit is an open-source Swift Package that helps Apple platform developers showcase and cross-promote their other apps in SwiftUI. Keep changes small, native, and suitable for indie developers shipping real apps.

## Project Scope

- Package name: `AppShelfKit`
- Main library target: `AppShelfKit`
- Test target: `AppShelfKitTests`
- Supported platforms:
  - iOS 17+
  - iPadOS 17+
  - macOS 14+
  - visionOS 1+
- Swift Package Manager is the source of truth.
- The package should remain lightweight and dependency-free unless a maintainer explicitly approves a dependency.

## Repository Structure

Keep source files organized under:

```text
Sources/AppShelfKit/
  Configuration/
  Models/
  Styles/
  Views/
  AppShelfKit.docc/

Tests/AppShelfKitTests/
Examples/AppShelfKitExample/
```

Do not move public API files into unrelated folders just for personal preference.

## Public API Guardrails

- Favor a small, stable public API.
- Do not rename public types, properties, enum cases, or initializers without treating it as a breaking change.
- Public types should include documentation comments.
- Public SwiftUI views must remain platform-compatible across iOS, iPadOS, macOS, and visionOS.
- Avoid UIKit-only or AppKit-only APIs unless conditionally compiled and clearly justified.
- Keep `Sendable`, `Codable`, `Hashable`, and `Identifiable` conformances intact where already present.
- Avoid adding global state, implicit networking, telemetry, analytics, or tracking.

## SwiftUI Guardrails

- Use native SwiftUI.
- Keep the default UI Apple-like, minimal, and readable.
- Support Dynamic Type.
- Avoid fixed heights where content may truncate.
- Add meaningful accessibility labels and hints for interactive elements.
- Treat app icons and SF Symbol placeholders as decorative unless they communicate unique information.
- Keep layouts useful for settings, about screens, and small cross-promotion surfaces.

## Networking and JSON Guardrails

- Remote JSON loading must remain optional.
- Tests must never perform real network calls.
- Validate HTTP responses before decoding remote JSON.
- Return meaningful public errors rather than swallowing failures silently.
- Do not scrape the App Store or call unofficial App Store APIs.
- Keep JSON configuration simple and predictable.

## Documentation Guardrails

- Keep `README.md`, `CHANGELOG.md`, and DocC documentation aligned with the public API.
- Update DocC pages when adding or changing public types.
- Include code snippets that compile conceptually and use current API names.
- Keep documentation friendly to indie Apple developers: practical, clear, and not over-marketed.
- For release work, keep known limitations honest.

## Testing Expectations

Run tests after code changes:

```sh
swift test
```

If the local environment requires Xcode explicitly:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test
```

Add or update tests when changing:

- `AppShelfItem`
- `AppShelfConfiguration`
- `AppShelfLoader`
- `AppStoreAppIdentifier`
- `AppShelfStyle`
- `AppShelfLayout`
- Codable behavior
- Public error behavior
- Remote loading behavior

Keep tests deterministic and free of external services.

## Release Guardrails

Before proposing a release:

- Verify `README.md` installation instructions.
- Update `CHANGELOG.md`.
- Run `swift test`.
- Confirm DocC documentation still matches the public API.
- Use semantic version tags such as `v0.1.0`.

For 0.x releases, clearly describe the package as early but usable.

## Change Hygiene

- Prefer focused changes over broad rewrites.
- Do not reformat unrelated files.
- Do not remove the example app unless explicitly requested.
- Do not introduce generated files, build artifacts, DerivedData, or `.build` contents.
- Do not commit secrets, credentials, private URLs, or production analytics endpoints.
- If a change cannot be verified locally, state that clearly in the final response.

# Contributing to AppShelfKit

Thanks for considering a contribution to AppShelfKit. This package is intentionally small: it should help indie Apple developers add a polished app shelf without pulling in extra dependencies or complex setup.

## Development Setup

1. Clone the repository.
2. Open the package in Xcode or work from the command line with Swift Package Manager.
3. Run the test suite before submitting changes.

```sh
swift test
```

If your local setup needs an explicit Xcode path:

```sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test
```

## Project Principles

- Keep the package lightweight and dependency-free.
- Prefer native SwiftUI and Foundation APIs.
- Keep the public API small, documented, and stable.
- Preserve support for iOS 17+, iPadOS 17+, macOS 14+, and visionOS 1+.
- Make accessibility and Dynamic Type good by default.
- Keep remote JSON loading optional.
- Never add real network calls to tests.

## Public API Changes

Treat these as public API:

- public types
- public properties
- public initializers
- public enum cases
- public error cases
- Codable JSON shape

Before changing public API, explain the motivation in the issue or pull request. For 0.x releases, the API can evolve, but changes should still be deliberate and documented.

## Tests

Add or update tests for changes to:

- `AppShelfItem`
- `AppShelfConfiguration`
- `AppShelfLoader`
- `AppStoreAppIdentifier`
- `AppShelfStyle`
- `AppShelfLayout`
- Codable behavior
- public error behavior
- mocked remote loading

Tests should be deterministic and should not depend on external services.

## Documentation

Update documentation when public behavior changes:

- `README.md` for setup and common usage
- `CHANGELOG.md` for release-facing changes
- DocC pages under `Sources/AppShelfKit/AppShelfKit.docc/`
- `llms.txt` if the repository map changes in a meaningful way

## Pull Request Checklist

Before opening a pull request:

- Run `swift test`.
- Keep the change focused.
- Add tests for behavior changes.
- Update docs for public API changes.
- Confirm the change works across the supported Apple platforms or explain any limitation.
- Avoid committing build artifacts, `.build`, DerivedData, secrets, or generated local files.

## AI-Assisted Contributions

AI-assisted contributions are welcome when they are reviewed carefully. Contributors are responsible for the final code, tests, documentation, and licensing of anything they submit.

If an AI tool generated or substantially rewrote code, mention that in the pull request description and describe how you verified the change.

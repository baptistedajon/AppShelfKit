# Release Checklist

Use this checklist for AppShelfKit releases.

## Before Release

- Confirm the release scope.
- Verify supported platforms still match `Package.swift` and `README.md`.
- Update `CHANGELOG.md`.
- Update `README.md` if installation, examples, or limitations changed.
- Update DocC documentation for public API changes.
- Update `llms.txt` if the repository map changed.
- Run the test suite.

```sh
swift test
```

- Run a whitespace check.

```sh
git diff --check
```

- For documentation changes, validate DocC when possible.

```sh
swift build --target AppShelfKit -Xswiftc -emit-symbol-graph -Xswiftc -emit-symbol-graph-dir -Xswiftc /tmp/AppShelfKitDocCSymbols
xcrun docc convert Sources/AppShelfKit/AppShelfKit.docc \
  --fallback-display-name AppShelfKit \
  --fallback-bundle-identifier dev.appshelfkit.AppShelfKit \
  --fallback-bundle-version 1.0.0 \
  --additional-symbol-graph-dir /tmp/AppShelfKitDocCSymbols \
  --output-path /tmp/AppShelfKitDocCOutput
```

## Tagging

Create an annotated semantic version tag:

```sh
git tag -a v0.1.0 -m "Release AppShelfKit 0.1.0"
git push origin v0.1.0
```

## GitHub Release

The release description should include:

- short positioning statement
- current highlights
- known limitations
- upgrade notes, if any
- test status

For 0.x releases, describe AppShelfKit as early but usable.

## After Release

- Confirm Swift Package Index ingestion.
- Confirm README links and GitHub release assets render correctly.
- Open follow-up issues for known limitations and roadmap items.

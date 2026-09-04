# HTTP Status Guide

An offline-first Flutter reference for HTTP status codes. Search codes quickly,
read practical explanations, and save frequently used codes for later.

## Download

Download the latest Android APK from the project's [Releases](../../releases)
page. On Android, open the downloaded APK and allow installation from your
browser or file manager when prompted.

Each release includes:

- `http-status-guide-<version>.apk` - installable Android package
- `http-status-guide-<version>.sha256` - checksum for verifying the download

## Features

- Works fully offline
- Browse status codes by category
- Search by code, name, or meaning
- View usage guidance and examples
- Bookmark useful status codes
- Share code details

## Development

### Requirements

- Flutter 3.x
- Dart 3.x
- Android Studio or an Android SDK for Android builds

### Run locally

```bash
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

### Build the Android APK

```bash
flutter build apk --release
```

The APK is generated at
`build/app/outputs/flutter-apk/app-release.apk`. Build output is intentionally
ignored by Git; releases are created by GitHub Actions.

## Creating a release

Push a version tag to build and publish the APK automatically:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The workflow in `.github/workflows/release.yml` builds the APK and attaches it
to a GitHub Release. Use a tag beginning with `v` for release builds.

## Contributing

Bug reports, documentation improvements, and pull requests are welcome. Please
keep changes focused and run `flutter test` before opening a pull request.

## License

Released under the [MIT License](LICENSE).

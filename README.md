# Flutter SDK

A Flutter module SDK that can be embedded into existing iOS and Android applications as prebuilt frameworks. This SDK provides a complete Flutter-based UI with API integration, dependency injection, and seamless integration with native apps.

## Overview

This repository contains a Flutter SDK module that can be integrated into native iOS and Android applications. The SDK is designed to be distributed as prebuilt frameworks (iOS) and AAR files (Android), allowing teams to integrate Flutter functionality without requiring all developers to have the Flutter toolchain installed.

## Project Structure

```
flutter_sdk_repo/
├── flutter_sdk/              # Flutter module source code
│   ├── lib/
│   │   ├── models/          # Data models (Post, Counter, etc.)
│   │   ├── services/        # Business logic and API services
│   │   ├── views/           # UI screens and widgets
│   │   ├── main.dart        # Embedded mode entry point
│   │   └── main_standalone.dart  # Standalone mode entry point
│   └── assets/              # Lottie animations and other assets
├── ios-example/             # iOS SwiftUI example app
└── example_android/         # Android example app
```

## Features

- ✅ **Prebuilt Framework Support**: Distribute as prebuilt frameworks/AARs
- ✅ **Dependency Injection**: Uses GetIt for service management
- ✅ **API Integration**: Built-in HTTP client with Dio
- ✅ **Dual Mode Support**: Embedded (MethodChannel) and Standalone modes
- ✅ **Modern UI**: Lottie animations, Material Design
- ✅ **Error Handling**: Comprehensive error handling with retry mechanisms
- ✅ **State Management**: Provider pattern for reactive UI

## Quick Start

### Building the Flutter SDK

To build the Flutter module as prebuilt frameworks/AARs:

**For iOS:**
```bash
cd flutter_sdk
flutter pub get
flutter build ios-framework --xcframework --output=../ios-example/Flutter
```

**For Android:**
```bash
cd flutter_sdk
flutter pub get
flutter build aar
```

This will generate frameworks/AARs for Debug, Profile, and Release configurations.

### iOS Integration

#### SwiftUI Example (`ios-example`)

1. Ensure Flutter frameworks are in `ios-example/Flutter/Debug/` (or Release/Profile)
2. Open `ios-example.xcodeproj` in Xcode
3. Build and run

See [ios-example/README.md](ios-example/README.md) for detailed instructions.

### Android Integration

1. Build the AAR as shown above
2. Add the AAR to your Android project
3. Configure dependencies in `build.gradle`

See [example_android/README.md](example_android/README.md) for detailed instructions.

## Flutter SDK Details

### Architecture

The Flutter SDK uses a clean architecture pattern:

- **Models**: Data classes with Equatable for value comparison
- **Services**: Business logic and API communication
- **Views**: UI components and screens
- **Dependency Injection**: GetIt for service registration

### Key Components

- **Counter Service**: Demonstrates MethodChannel communication (embedded mode) or local state (standalone mode)
- **Posts Service**: API integration example using Dio
- **Posts View**: List view with pull-to-refresh and error handling
- **Details Page**: Detail view with API integration

### Running Standalone

The SDK can run in standalone mode for development/testing:

```bash
cd flutter_sdk
flutter pub get
flutter run
```

Or use the VS Code launch configurations in `.vscode/launch.json`.

## Requirements

- **Flutter SDK**: 3.9.0 or higher
- **iOS**: 
  - Xcode 14.0+
  - iOS 12.4+
- **Android**:
  - Android Studio
  - minSdkVersion 24+

## Dependencies

The Flutter SDK uses the following key dependencies:

- `provider`: State management
- `get_it`: Dependency injection
- `dio`: HTTP client
- `dartz`: Functional programming utilities
- `equatable`: Value equality
- `lottie`: Animations

## Development

### Project Setup

1. Clone the repository
2. Navigate to `flutter_sdk/`
3. Run `flutter pub get`
4. Open in your preferred IDE (VS Code or Android Studio)

### Building for Distribution

When ready to distribute:

1. Build frameworks/AARs for all configurations (Debug, Profile, Release)
2. Distribute the prebuilt files to your team
3. Teams can integrate without Flutter SDK installed

## Documentation

- [Flutter SDK README](flutter_sdk/README.md) - Detailed Flutter module documentation
- [iOS Example README](ios-example/README.md) - iOS SwiftUI integration guide
- [Android Example README](example_android/README.md) - Android integration guide

## License

Copyright © 2026 Nabraj Khadka

## Support

For issues and questions, please refer to the individual README files in each example directory or check the Flutter [add-to-app documentation](https://docs.flutter.dev/add-to-app).

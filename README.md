# Flutter SDK

A Flutter module SDK that can be embedded into existing iOS and Android applications as prebuilt frameworks. This SDK provides a complete Flutter-based UI with API integration, dependency injection, and seamless integration with native apps.

## Overview

This repository contains a Flutter SDK module that can be integrated into native iOS and Android applications. The SDK is designed to be distributed as prebuilt frameworks (iOS) and AAR files (Android), allowing teams to integrate Flutter functionality without requiring all developers to have the Flutter toolchain installed.

For Android integration, the Flutter AAR files are distributed via a separate Maven repository hosted on GitHub Pages. See the [Maven Repository Documentation](https://github.com/iamnabink/flutter-android-sdk-maven-repo) for detailed information about Maven repository hosting, distribution, and usage.

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

Once the Flutter module is linked into your application, you're ready to fire up an instance of the Flutter engine and present the Flutter view controller.

#### Step 1: Link Flutter Frameworks

Download the prebuilt Flutter frameworks and add them to your Xcode project:

1. Open the `Flutter/Release` directory (or Debug/Profile based on your build configuration)
2. Drag `App.xcframework` and `Flutter.xcframework` to the **General > Frameworks, Libraries, and Embedded Content** section of your app target in Xcode
3. Ensure both frameworks are set to "Embed & Sign"

#### Step 2: Set Up Flutter Engine in AppDelegate

Create new `AppDelegate.swift`, instantiate and run the Flutter engine:

```swift
import UIKit
import Flutter

class AppDelegate: UIResponder, UIApplicationDelegate {
    var flutterEngine: FlutterEngine?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Instantiate Flutter engine
        self.flutterEngine = FlutterEngine(name: "io.flutter", project: nil)
        self.flutterEngine?.run(withEntrypoint: nil)
        return true
    }
}
```

For SwiftUI apps, use `@UIApplicationDelegateAdaptor`:

```swift
@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

#### Step 3: Present Flutter View Controller

In any ViewController (typically in response to a button press), present the Flutter module's UI:

```swift
let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
present(flutterViewController, animated: true, completion: nil)
```

Once executed, the Flutter UI will appear in your app!

For more detailed instructions, see [ios-example/README.md](ios-example/README.md).

### Android Integration

Once the Flutter module is linked into your application, you need to fire up an instance of the Flutter engine and present the Flutter Activity.

#### Step 1: Configure Dependencies

Add the AAR repository and dependencies in your `app/build.gradle`. The Flutter AAR files are hosted in a separate Maven repository:

```gradle
repositories {
    maven {
        // Maven repository hosted on GitHub Pages
        url 'https://iamnabink.github.io/flutter-android-sdk-maven-repo'
    }
    maven {
        url 'https://storage.googleapis.com/download.flutter.io'
    }
    google()
    mavenCentral()
}
```

For more information about the Maven repository structure, hosting, and alternative setup options, see the [Maven Repository Documentation](https://github.com/iamnabink/flutter-android-sdk-maven-repo).

**Add Dependencies:**

```gradle
dependencies {
    releaseImplementation ('dev.nabrajkhadka.example.flutter_module:flutter_release:1.0@aar') {
        transitive = true
    }
    debugImplementation ('dev.nabrajkhadka.example.flutter_module:flutter_debug:1.0@aar') {
        transitive = true
    }
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

#### Step 2: Configure AndroidManifest.xml

Add the Flutter embedding metadata inside your `<application>` tag:

```xml
<meta-data
    android:name="flutterEmbedding"
    android:value="2" />
```

Also add the FlutterActivity:

```xml
<activity
    android:name="io.flutter.embedding.android.FlutterActivity"
    android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density"
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize"
    android:exported="true" />
```

#### Step 3: Set Up Flutter Engine in Application Class

In your app's `Application` class, instantiate and cache a running Flutter engine. This pre-warms the engine for better performance:

```kotlin
import androidx.multidex.MultiDexApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

const val ENGINE_ID = "1" // or any unique identifier

class MyApplication : MultiDexApplication() {
    override fun onCreate() {
        super.onCreate()

        // Instantiate a FlutterEngine
        val flutterEngine = FlutterEngine(this)

        // Start executing Dart code to pre-warm the FlutterEngine
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        // Cache the FlutterEngine to be used by FlutterActivity
        FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)
    }
}

#### Step 4: Launch Flutter Activity

In any Activity class (typically in response to a button press or other UI event), launch the Flutter module's UI:

```kotlin
import io.flutter.embedding.android.FlutterActivity

// In your Activity's onCreate or button click handler
val intent = FlutterActivity
    .withCachedEngine(ENGINE_ID)
    .build(this)
startActivity(intent)
```

**Example from MainActivity:**

```kotlin
button.setOnClickListener {
    val intent = FlutterActivity
        .withCachedEngine(ENGINE_ID)
        .build(this)
    startActivity(intent)
}
```

Once executed, the Flutter UI will appear in your app!

For more detailed instructions, see [example_android/README.md](example_android/README.md).

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

## Limitations

**Packing Multiple Flutter Libraries**: In add-to-app setups, it's essential to understand that packing multiple Flutter libraries into an application isn't directly supported. Each Flutter module is typically integrated into a specific native app module, and there may be challenges when attempting to include multiple Flutter modules within the same native app.

**Performance Overhead**: While Flutter provides excellent performance out-of-the-box, integrating Flutter into an existing app may introduce additional performance overhead, especially if not optimised properly.

**Testing and Debugging**: Testing and debugging can be more challenging in an add-to-app setup, especially when dealing with issues that span both Flutter and native code.

**Support for AndroidX**: In add-to-app setups on Android, the Flutter module only supports AndroidX applications. AndroidX is the modern Android library suite that replaces the now-deprecated Android Support Libraries.

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

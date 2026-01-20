# ios-example

An example iOS application demonstrating the usage of the Flutter SDK. This is a SwiftUI-based iOS app that integrates with Flutter modules using prebuilt frameworks.

## Description

This project demonstrates how to integrate a prebuilt Flutter module into an existing SwiftUI iOS application. The Flutter module is provided as prebuilt frameworks (`App.xcframework` and `Flutter.xcframework`), which means you don't need the Flutter SDK installed to use this project.

This approach is useful for teams that don't want to require every developer working on the app to have the Flutter toolchain installed on their local machines.

## Prerequisites

Before you begin, ensure you have the following:

* **Xcode** - Latest version from the App Store
* **Prebuilt Flutter Frameworks** - The `App.xcframework` and `Flutter.xcframework` files should be provided in the `Flutter/` directory

## Step 1: Verify Flutter Frameworks

Ensure that the prebuilt Flutter frameworks are available in the correct location:

```
ios-example/
└── Flutter/
    ├── Debug/
    │   ├── App.xcframework
    │   └── Flutter.xcframework
    ├── Profile/
    │   ├── App.xcframework
    │   └── Flutter.xcframework
    └── Release/
        ├── App.xcframework
        └── Flutter.xcframework
```

The project is configured to automatically find the correct framework based on your build configuration (Debug, Profile, or Release).

## Step 2: Open the Project

Open the Xcode project:

```bash
open ios-example.xcodeproj
```

Or open it directly in Xcode by double-clicking `ios-example.xcodeproj`.

## Step 3: Project Configuration

The project is already configured with the necessary settings:

### Framework Search Paths
- `FRAMEWORK_SEARCH_PATHS` includes `$(PROJECT_DIR)/Flutter/$(CONFIGURATION)`
- This allows Xcode to find frameworks in `Flutter/Debug/`, `Flutter/Profile/`, or `Flutter/Release/` based on build configuration

### Info.plist Settings
- `NSBonjourServices` with `_dartobservatory._tcp` for Flutter debugging
- `NSLocalNetworkUsageDescription` for Flutter tools connectivity

### Embedded Frameworks
- `App.xcframework` and `Flutter.xcframework` are configured to be embedded in the app

## Step 4: Understanding the Implementation

### AppDelegate Setup

The `AppDelegate` class initializes the Flutter engine when the app launches:

```swift
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

### SwiftUI App Integration

The SwiftUI app uses `@UIApplicationDelegateAdaptor` to integrate the AppDelegate:

```swift
@main
struct ios_exampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.appDelegate, appDelegate)
        }
    }
}
```

### Presenting Flutter View

To present a Flutter view controller from SwiftUI:

```swift
func openFlutterView() {
    guard let appDelegate = appDelegate ?? (UIApplication.shared.delegate as? AppDelegate),
          let flutterEngine = appDelegate.flutterEngine else {
        return
    }
    
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          let rootViewController = window.rootViewController else {
        return
    }
    
    let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    rootViewController.present(flutterViewController, animated: false, completion: nil)
}
```

### Method Channel Communication

The example includes method channel setup for bidirectional communication between iOS and Flutter:

```swift
methodChannel = FlutterMethodChannel(name: "dev.flutter.example/counter",
                                     binaryMessenger: flutterEngine.binaryMessenger)
methodChannel?.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
    // Handle method calls from Flutter
})
```

## Step 5: Build and Run

1. Select your target device or simulator in Xcode
2. Choose the appropriate build configuration (Debug or Release)
3. Build and run the project (⌘R)

## Troubleshooting

### Error: "Engine run configuration was invalid"

This error occurs when Flutter frameworks are missing or not properly configured. Ensure:

1. **Frameworks are present**: Check that `Flutter/Debug/`, `Flutter/Profile/`, or `Flutter/Release/` (depending on your build configuration) contains both `App.xcframework` and `Flutter.xcframework`
2. **Frameworks are embedded**: Verify in Xcode that both frameworks are listed under "Embed Frameworks" build phase
3. **Correct build configuration**: Ensure you're using the correct build configuration (Debug frameworks for Debug builds, Profile frameworks for Profile builds, Release frameworks for Release builds)

### Error: "Flutter engine not available"

This means the AppDelegate's `flutterEngine` is nil. Check:

1. AppDelegate is properly initialized via `@UIApplicationDelegateAdaptor`
2. `didFinishLaunchingWithOptions` is being called
3. Flutter engine initialization is successful (check for errors in console)

### Frameworks not found during build

1. Verify `FRAMEWORK_SEARCH_PATHS` includes `$(PROJECT_DIR)/Flutter/$(CONFIGURATION)`
2. Ensure frameworks are built for the correct configuration (Debug vs Release)
3. Clean build folder (Product → Clean Build Folder) and rebuild

### Flutter view shows blank screen

1. Check that Flutter assets are included in the `App.xcframework`
2. Verify the Flutter module's `main.dart` entry point is correct
3. Check Xcode console for Flutter-specific errors

## Updating Flutter Frameworks

When new versions of the Flutter frameworks are provided, simply replace the frameworks in the `Flutter/` directory:

1. Replace `Flutter/Debug/App.xcframework` and `Flutter/Debug/Flutter.xcframework` for debug builds
2. Replace `Flutter/Profile/App.xcframework` and `Flutter/Profile/Flutter.xcframework` for profile builds
3. Replace `Flutter/Release/App.xcframework` and `Flutter/Release/Flutter.xcframework` for release builds
4. Clean build folder in Xcode (Product → Clean Build Folder)
5. Rebuild your iOS app

**Note:** You don't need Flutter SDK installed to use this project. The frameworks are prebuilt and provided separately.

## Project Structure

```
ios-example/
├── ios-example/
│   ├── ios_exampleApp.swift    # SwiftUI app entry point with AppDelegate
│   └── ContentView.swift        # Main SwiftUI view with Flutter integration
├── Flutter/
│   ├── Debug/                  # Debug frameworks (prebuilt)
│   │   ├── App.xcframework
│   │   └── Flutter.xcframework
│   ├── Profile/                # Profile frameworks (prebuilt)
│   │   ├── App.xcframework
│   │   └── Flutter.xcframework
│   └── Release/                # Release frameworks (prebuilt)
│       ├── App.xcframework
│       └── Flutter.xcframework
└── ios-example.xcodeproj       # Xcode project file
```

## Additional Resources

- [Flutter Add-to-App Documentation](https://docs.flutter.dev/add-to-app)
- [Flutter iOS Integration Guide](https://docs.flutter.dev/add-to-app/ios/project-setup)
- [Flutter Method Channels](https://docs.flutter.dev/platform-integration/platform-channels)

## Requirements

* **Xcode** 14.0 or later
* **iOS** 12.4 or later
* **Prebuilt Flutter Frameworks** - Provided separately (no Flutter SDK required)

## Note

This project uses **prebuilt Flutter frameworks**, which means:
- ✅ You don't need Flutter SDK installed
- ✅ You don't need to build Flutter modules
- ✅ Just use the provided frameworks and integrate them into your iOS app

The frameworks are built separately and provided in the `Flutter/` directory. This allows teams to integrate Flutter functionality without requiring all developers to have the Flutter toolchain installed.

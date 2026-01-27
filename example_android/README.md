# android_using_prebuilt_module

An example Android application demonstrating how to integrate a prebuilt AAR library from a Maven repository.

This example shows how to consume Flutter AAR files from a Maven repository. The Maven repository is hosted separately on GitHub Pages. For detailed information about the Maven repository structure, hosting, distribution, and usage, see the [Maven Repository Documentation](https://github.com/iamnabink/flutter-android-sdk-maven-repo).

## Integration Steps

### 1. Add Repositories

In `app/build.gradle`, add the Maven repository containing the Flutter AAR files:

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

For more information about the Maven repository structure, hosting options, and alternative setup methods, see the [Maven Repository Documentation](https://github.com/iamnabink/flutter-android-sdk-maven-repo).

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

**Understanding Maven Coordinates:**
- `dev.nabrajkhadka.example.flutter_module` - Group ID (organization/package identifier)
- `flutter_release` / `flutter_debug` - Artifact ID (library name)
- `1.0` - Version number
- `@aar` - Specifies this is an AAR file format
- `transitive = true` - Includes all dependencies of the AAR

### 2. Configure AndroidManifest.xml

Add inside `<application>`:

```xml
<meta-data
    android:name="flutterEmbedding"
    android:value="2" />
```

### 3. Launch SDK

```kotlin
import io.flutter.embedding.android.FlutterActivity

val intent = FlutterActivity
    .withCachedEngine("engine_id")
    .build(this)
startActivity(intent)
```

## Requirements

- minSdkVersion: 24+
- Kotlin: 2.2.0+
- Java: 17+

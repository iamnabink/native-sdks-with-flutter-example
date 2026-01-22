# android_using_prebuilt_module

An example Android application demonstrating how to integrate a prebuilt AAR library from a Maven repository.

This example shows how to consume Flutter AAR files from a Maven repository. The Maven repository for this example is located in `../maven-repo/` and can be used locally or referenced remotely. For information about hosting and distributing Maven repositories, see [maven-repo/README.md](../maven-repo/README.md).

## Integration Steps

### 1. Add Repositories

In `app/build.gradle`, add the Maven repository containing the Flutter AAR files:

**Option 1: Local Maven Repository**

```gradle
repositories {
    maven {
        // Local Maven repository from this example project
        url '../maven-repo'
    }
    maven {
        url 'https://storage.googleapis.com/download.flutter.io'
    }
    google()
    mavenCentral()
}
```

**Option 2: Remote Maven Repository**

```gradle
repositories {
    maven {
        // Remote Maven repository URL
        url 'https://iamnabink.github.io/flutter-android-sdk-maven-repo'
    }
    maven {
        url 'https://storage.googleapis.com/download.flutter.io'
    }
    google()
    mavenCentral()
}
```

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

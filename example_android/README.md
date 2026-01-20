# android_using_prebuilt_module

An example Android application demonstrating how to integrate a prebuilt AAR library.

## Integration Steps

### 1. Add Repositories

In `app/build.gradle`:

```gradle
repositories {
    maven {
        url '<path-to-aar-repository>'
    }
    maven {
        url 'https://storage.googleapis.com/download.flutter.io'
    }
    google()
    mavenCentral()
}

dependencies {
    releaseImplementation ('dev.flutter.example.flutter_module:flutter_release:1.0@aar') {
        transitive = true
    }
    debugImplementation ('dev.flutter.example.flutter_module:flutter_debug:1.0@aar') {
        transitive = true
    }
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

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

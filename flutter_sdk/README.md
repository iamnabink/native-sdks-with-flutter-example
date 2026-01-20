# Android SDK Integration Guide

Quick setup guide to integrate the AAR library into your native Android app.

## Prerequisites

- **minSdkVersion**: 24 or higher
- **Kotlin**: 2.2.0 or higher
- **Java**: 17 or higher

## Step 1: Add Repositories

Add to your `app/build.gradle` or root `build.gradle`:

```gradle
repositories {
    // AAR repository path (adjust to your distribution location)
    maven {
        url '<path-to-aar>'
    }
    
    // Required: SDK dependencies repository
    maven {
        url 'https://storage.googleapis.com/download.flutter.io'
    }
    
    google()
    mavenCentral()
}
```

## Step 2: Add Dependencies

Add to your `app/build.gradle`:

```gradle
dependencies {
    // Release build
    releaseImplementation ('dev.flutter.example.flutter_module:flutter_release:1.0@aar') {
        transitive = true
    }
    
    // Debug build
    debugImplementation ('dev.flutter.example.flutter_module:flutter_debug:1.0@aar') {
        transitive = true
    }
    
    // Required: MultiDex support
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

**Note:** `transitive = true` is required to include SDK dependencies.

## Step 3: Configure AndroidManifest.xml

Add to your `AndroidManifest.xml` inside `<application>`:

```xml
<meta-data
    android:name="flutterEmbedding"
    android:value="2" />
```

## Step 4: Launch SDK Screen

```kotlin
import io.flutter.embedding.android.FlutterActivity

// Launch SDK screen
val intent = FlutterActivity
    .withCachedEngine("your_engine_id")
    .build(this)
startActivity(intent)
```

## Troubleshooting

- **"Could not find flutter_embedding"**: Ensure SDK dependencies repository is added
- **"minSdkVersion mismatch"**: Set minSdkVersion to 24 or higher
- **"Out of memory"**: Add to `gradle.properties`: `org.gradle.jvmargs=-Xmx4096m`

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.astrodarshan.user"
    
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true   // ✅ Enable desugaring
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.astrodarshan.user"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        
    }

    buildTypes {
        release {
            isMinifyEnabled = true  // ✅ Use "isMinifyEnabled" instead of "minifyEnabled"
            isShrinkResources = true  // ✅ Use "isShrinkResources" instead of "shrinkResources"
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
 
 configurations.all {
    resolutionStrategy {
        eachDependency {
            if (requested.group == "com.android.tools" && requested.name == "desugar_jdk_libs") {
                useVersion("2.1.5") // ✅ Force the correct version
            }
        }
    }
}
// Enables Jetifier & AndroidX support
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation(platform("com.google.firebase:firebase-bom:33.13.0"))
    implementation("androidx.multidex:multidex:2.0.1")
   // coreLibraryDesugaring ('com.android.tools:desugar_jdk_libs:1.2.2')
}
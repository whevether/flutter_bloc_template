import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
val localProperties = Properties()

// 加载打包key
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    localProperties.load(FileInputStream(keystorePropertiesFile))
}
android {
    namespace = "com.example.flutter_bloc_template"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.3.13750724"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

   kotlinOptions {
       jvmTarget = JavaVersion.VERSION_1_8.toString()
   }
    packaging {
        dex {
            useLegacyPackaging = true
        }
        jniLibs {
            useLegacyPackaging = true
        }
    }
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.flutter_bloc_template"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        ndk {
            abiFilters += listOf("arm64-v8a", "x86_64")
        }
    }
    signingConfigs {
        create("release") {
            keyAlias = localProperties["keyAlias"] as String
            keyPassword = localProperties["keyPassword"] as String
            storeFile = localProperties["storeFile"]?.let { file(it as String) }
            storePassword = localProperties["storePassword"] as String
            // isMinifyEnabled = true
            // isShrinkResources = false
            // enableProguard = true
        }
    }
    buildTypes {
       debug {
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
            // minifyEnabled = true
            // shrinkResources = true
            // proguardFiles = getDefaultProguardFile(
            //             'proguard-android-optimize.txt'),
            //             'proguard-rules.pro'
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                    "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

plugins {
    id("org.jetbrains.kotlin.multiplatform")
    id("org.jetbrains.kotlin.plugin.compose")
    id("org.jetbrains.compose")
    id("com.android.application")
}

kotlin {
    androidTarget {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
    iosArm64 {
        binaries.framework { baseName = "VoltaviaShared" }
    }
    iosSimulatorArm64 {
        binaries.framework { baseName = "VoltaviaShared" }
    }
    wasmJs {
        browser()
        binaries.executable()
    }

    sourceSets {
        commonMain.dependencies {
            implementation(compose.runtime)
            implementation(compose.foundation)
            implementation("org.jetbrains.compose.material3:material3:1.5.0")
            implementation(compose.ui)
            implementation("androidx.datastore:datastore-core:1.3.0")
            implementation("androidx.datastore:datastore-core-okio:1.3.0")
            implementation("androidx.datastore:datastore-preferences-core:1.3.0")
            implementation("com.squareup.okio:okio:3.16.0")
        }
        androidMain.dependencies {
            implementation("androidx.activity:activity-compose:1.12.0")
        }
    }
}

android {
    namespace = "com.ferdidrgn.voltavia.kmp"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.ferdidrgn.voltavia.kmp"
        minSdk = 24
        targetSdk = 36
        versionCode = 1
        versionName = "0.1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

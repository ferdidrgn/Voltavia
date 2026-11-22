# Voltavia KMP

Compose Multiplatform starter for the Voltavia EV charging product. It lives beside the current Flutter application so migration can be evaluated incrementally.

## Targets

- Android application
- iOS ARM64 and Apple Silicon simulator framework
- Browser preview using Kotlin/Wasm and shared Compose UI (beta)
- Shared UI and product state in `composeApp/src/commonMain`

## First UI slice

- Interactive bottom navigation for map, stations, route planning, vehicle profile, and account/theme profile
- Searchable station list, details, filters, favorites, and map-style preview using clearly illustrative sample data
- User-selectable Harbor green, Rose, Violet, Amber, light Glass, Rose Glass, and Violet Glass palettes
- Independent light/dark mode, custom HEX accent color, and persisted theme/favorite/vehicle settings with KMP DataStore Preferences
- Searchable starter EV catalogue with variant selection; the selected vehicle appears on Home and Profile and is used by the route estimate
- Vehicle consumption/reserve estimates and transparent energy calculation for a user-entered distance
- Material 3 components and theme system

The station and route samples are UI-only mock data. They are not live network responses. Tariff/status are unknown, and charging start is disabled until an operator integration is verified.

The route-energy result is an estimate based on user input. It does not provide road geometry, live vehicle data, or a charging-stop guarantee. Station facts carry source, update time, and confidence fields, but no licensed production feed is connected yet.

## Build

Open this directory as a Gradle project in Android Studio with Kotlin Multiplatform support. Android debug build: `./gradlew :composeApp:assembleDebug` (Windows: `gradlew.bat :composeApp:assembleDebug`). iOS builds require macOS and Xcode. Pin or update Compose Multiplatform, Kotlin, Android Gradle Plugin, and Material 3 together according to JetBrains' compatibility table before release.

Run the browser preview from this directory with `./gradlew :composeApp:wasmJsBrowserDevelopmentRun` (Windows: `gradlew.bat :composeApp:wasmJsBrowserDevelopmentRun`). The browser stores settings in local storage. Compose Multiplatform's web target is currently beta, so use it for preview/testing rather than treating it as a release build without platform validation.


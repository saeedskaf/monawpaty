# Monawpaty

A Flutter mobile app for **medical-staff shift & on-call management**. Doctors
onboard, verify their phone via OTP, then browse, book, cancel, and repair duty
shifts, view hospital locations on a map, and read reference directories (PDF) —
all in a fully right-to-left (RTL) Arabic interface.

> **Portfolio notice.** This is a real client project published here for
> portfolio/showcase purposes only. It is **source-available, not open source** —
> see [LICENSE](LICENSE). All API keys, Firebase config, and the backend endpoint
> have been removed from the repository and are injected at build time.

---

## Features

- **Onboarding & welcome** flow with a smooth page indicator and native splash.
- **Phone-based registration** with OTP verification.
- **Authentication**: login, logout, forgot/reset password, change password
  (Firebase Auth + a custom REST backend).
- **Shift booking**: browse available shifts in a calendar/table, reserve shifts,
  and request on-call posts.
- **Shift changes**: request cancellation or "repair" of an existing reservation
  and track the request status.
- **Profile**: view personal info, "my shifts", and account settings.
- **Maps**: hospital/branch locations via Google Maps.
- **Reference PDFs**: cached, offline-friendly viewing of directories
  (doctors, hospitals, operations, rules of procedure).
- **Localized RTL UI** using the Cairo Arabic font.

## Tech stack

| Area | Choice |
|------|--------|
| Language / SDK | Dart, Flutter |
| State management | `bloc` / `flutter_bloc` (Cubit pattern) |
| Dependency injection | `get_it` service locator |
| Networking | `http` against a REST API (bearer-token auth) |
| Local storage | `shared_preferences` |
| Auth & backend services | Firebase Core / Firebase Auth |
| Maps | `google_maps_flutter` |
| Misc | `intl_phone_field`, `otp_text_field`, `flutter_cached_pdfview`, `google_fonts`, `flutter_native_splash`, `url_launcher` |

## Architecture overview

The app uses a **feature-first** layout with the **Cubit** flavor of BLoC for
state management and a `get_it` service locator for shared singletons.

```
lib/
├── main.dart                     # App entry: Firebase init, locator, splash, routing
├── core/
│   ├── locator.dart              # get_it registrations (SharedPreferences, repos)
│   └── shared_prefrence_repository.dart
└── src/
    ├── layout/                   # Top-level app shell + layout cubit
    ├── models/                   # Plain Dart models (user, shift)
    ├── modules/                  # One folder per feature, each with its own cubit(s)
    │   ├── on_board/  welcome/  login/  registration/  otp/
    │   ├── home/      profile/  map/    pdf/
    │   └── shifts_booking/  shifts_changes/  splash/
    └── shared/                   # Cross-cutting code
        ├── end_points.dart       # API route constants (base URL injected, see setup)
        ├── app_config.dart       # gitignored — real local config
        ├── app_config.example.dart
        ├── components/  styles/  bloc_observer.dart
```

Each feature module typically contains a `*_screen.dart` (UI) and a `cubit/`
folder (`*_cubit.dart` + `*_state.dart`) that owns the screen's state and talks
to the backend.

## Getting started

### Prerequisites

- Flutter SDK (3.x) and the Android/iOS toolchains
- A Firebase project (for Auth) and Google Maps API keys

### 1. Clone & install

```bash
git clone <your-fork-url> monawpaty
cd monawpaty
flutter pub get
```

### 2. Supply the injected secrets

Secrets are **not** committed. Copy each template to its real filename (the real
files are gitignored) and fill in your values:

| Template (committed) | Real file (gitignored) | Holds |
|----------------------|------------------------|-------|
| `lib/src/shared/app_config.example.dart` | `lib/src/shared/app_config.dart` | Backend base URL |
| `android/secrets.properties.example` | `android/secrets.properties` | Android Google Maps key |
| `ios/Flutter/Secrets.xcconfig.example` | `ios/Flutter/Secrets.xcconfig` | iOS Google Maps key |
| `android/app/google-services.json.example` | `android/app/google-services.json` | Firebase Android config |
| `ios/Runner/GoogleService-Info.plist.example` | `ios/Runner/GoogleService-Info.plist` | Firebase iOS config |

```bash
cp lib/src/shared/app_config.example.dart        lib/src/shared/app_config.dart
cp android/secrets.properties.example            android/secrets.properties
cp ios/Flutter/Secrets.xcconfig.example          ios/Flutter/Secrets.xcconfig
cp android/app/google-services.json.example      android/app/google-services.json
cp ios/Runner/GoogleService-Info.plist.example   ios/Runner/GoogleService-Info.plist
```

Then open each copied file and replace the placeholder values. For the Firebase
files, the easiest path is to run `flutterfire configure` against your own
Firebase project, which regenerates them.

**How injection works**

- **Backend URL** — `end_points.dart` reads `AppConfig.baseUrl` from the
  gitignored `app_config.dart`.
- **Android Maps key** — `android/app/build.gradle` loads `MAPS_API_KEY` from
  `secrets.properties` and feeds it into the manifest via
  `manifestPlaceholders` (`${MAPS_API_KEY}`).
- **iOS Maps key** — `Secrets.xcconfig` defines `MAPS_API_KEY`, which is exposed
  to `Info.plist` as `$(MAPS_API_KEY)` and read by `AppDelegate.swift` at launch.

### 3. Run

```bash
flutter run
```

## License

Proprietary — **All rights reserved.** Published for portfolio viewing only.
See [LICENSE](LICENSE).

# HInsight - Frontend Repository

This is the frontend repository for the HInsight decision-tracking application. 

This project strictly adheres to **Feature-First Clean Architecture** to ensure scalability, maintainability, and a strict separation of concerns. UI components, business logic, and API calls are completely isolated.

## Tech Stack Overview
* **UI Framework:** Flutter
* **State Management:** Riverpod (`flutter_riverpod`)
* **Routing:** GoRouter
* **Networking:** Dio
* **Local Database:** Isar
* **Code Generation:** Freezed & JSON Serializable

---

## 1. Prerequisites & Installation

If you do not have the Flutter SDK installed on your machine, you must configure your environment first.

### Environment Setup
1. **Download the SDK:** Download the latest stable release from the [official Flutter website](https://docs.flutter.dev/get-started/install).
2. **Extract:** Extract the downloaded file to a permanent, non-elevated location (e.g., `C:\src\flutter` on Windows, or `~/development/flutter` on macOS).
3. **Update your PATH:** Add the `flutter/bin` directory to your system's Environment Variables (Windows) or `.bashrc` / `.zshrc` profile (macOS/Linux).
4. **Verify Installation:** Restart your terminal and run the following commands to ensure your machine recognizes Flutter and to check for missing build tools:
   ```bash
   flutter --version
   flutter doctor
   ```

> **Use Flutter 3.47.x (stable), the same version as the rest of the team.** The committed `pubspec.lock` was resolved with 3.47, and each Flutter SDK pins its own versions of packages like `meta` and `test_api`. On an older SDK (e.g. 3.41), `flutter pub get` rewrites `pubspec.lock` with older versions. Run `flutter --version` to check, and `flutter upgrade` to update. Don't commit a `pubspec.lock` that changed only because of your SDK version.

---

## 2. Project Initialization

Once Flutter is installed and your IDE is ready, clone this repository and initialize the project. 

```bash
# 1. Clone the repository
git clone https://github.com/HInsight-app/frontend.git
cd frontend

# 2. Configure your own Git identity (if not already set globally)
git config user.name "Your Name"
git config user.email "you@example.com"

# 3. Create your local environment file, then set BASE_URL to the backend's URL
#    (in Windows cmd use: copy .env.example .env)
cp .env.example .env

# 4. Fetch all dependencies from pubspec.yaml
flutter pub get

# 5. Generate the required boilerplate code (Freezed models, Isar schemas, etc.)
# DO NOT SKIP THIS STEP. The app will fail to compile without it.
dart run build_runner build -d
```
*Note: Whenever you modify a `.dart` file that uses `@freezed`, `@JsonSerializable`, or Isar collections, you must re-run the `build_runner` command to update the generated code.*

*Note: `.env` is git-ignored but listed as an asset in `pubspec.yaml`, so the app will not build until the file exists.*

*Note: `isar_generator` 3.1 pins `analyzer` to 5.x, which keeps `freezed` and `json_serializable` on their current major versions. Don't upgrade those two until Isar is upgraded or replaced.*

---

##  3. Running the App

HInsight is a **mobile-first** app (Android/iOS), which is also what the thesis evaluates. Web is only a quick UI preview.

### Running on Mobile (Emulator or Physical Device)
Ensure your Android Emulator or iOS Simulator is running, or a physical device is connected via USB/Wi-Fi, then run:
```bash
flutter run
```

### Running on Web (UI Preview Only)
Isar does not support web. Once the app opens Isar at startup, the web build will not start at all, so treat web as a temporary way to check layouts and styling.

To run the app directly in your existing Chrome browser without spawning a new, sandboxed debugging window, use the web-server configuration:
```bash
flutter run -d web-server --web-port 8080
```
Once the server starts, open your browser and navigate to `http://localhost:8080`.

---

## 4. Folder Architecture

All active code lives inside the `lib/` directory. Do not add business logic to `main.dart`. We group files by **Feature** (what it does), not by file type (what it is). 

```text
lib/
├── main.dart                 # Entry point. Initializes Riverpod ProviderScope.
└── src/
    ├── core/                 # App-wide shared utilities (NO feature-specific logic)
    │   ├── constants/
    │   ├── network/          # Base Dio client & interceptors
    │   ├── routing/          # GoRouter configuration
    │   ├── theme/
    │   └── widgets/          # Shared, generic UI components (e.g., PrimaryButton)
    │
    └── features/             # Isolated, plug-and-play capability modules
        ├── auth/
        ├── home/
        └── [feature_name]/
            ├── data/         # API calls, JSON DTOs, and concrete repositories
            ├── domain/       # Pure Dart: Freezed entities and abstract repository contracts
            └── presentation/ # Flutter UI: Pages, widgets, and Riverpod controllers
```

### The Golden Rules of the Codebase
1. **The Domain Layer is isolated:** `domain/` must never import `flutter/material.dart` or `dio`. It is 100% pure Dart business logic.
2. **No API calls in the UI:** Your `presentation/` widgets must never talk to the `data/` layer directly. Widgets ask the `presentation/controllers/` (Riverpod) for state, and those controllers interact with the data repositories.
3. **No imperative routing:** Use GoRouter for all navigation. Do not use `Navigator.push()`.
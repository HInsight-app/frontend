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

---

## 2. Project Initialization

Once Flutter is installed and your IDE is ready, clone this repository and initialize the project. 

```bash
# 1. Clone the repository
git clone [https://github.com/Sebastian/hinsight-frontend.git](https://github.com/Sebastian/hinsight-frontend.git)
cd hinsight-frontend

# 2. Configure local Git identity (if not already set globally)
git config user.name "Sebastian"
git config user.email "sebastianramli77@gmail.com"

# 3. Fetch all dependencies from pubspec.yaml
flutter pub get

# 4. Generate the required boilerplate code (Freezed models, Isar schemas, etc.)
# DO NOT SKIP THIS STEP. The app will fail to compile without it.
dart run build_runner build -d
```
*Note: Whenever you modify a `.dart` file that uses `@freezed`, `@JsonSerializable`, or Isar collections, you must re-run the `build_runner` command to update the generated code.*

---

##  3. Running the App

### Running on Mobile (Emulator or Physical Device)
Ensure your Android Emulator or iOS Simulator is running, or a physical device is connected via USB/Wi-Fi, then run:
```bash
flutter run
```

### Running on Web (Local Browser Tab)
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
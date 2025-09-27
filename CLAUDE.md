# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Game Release Calendar is a Flutter mobile application that tracks video game release dates with smart notifications and advanced filtering capabilities. It uses the IGDB (Internet Game Database) API for game data and supports Android, iOS, Web, Windows, macOS, and Linux platforms.

## Essential Commands

**Environment Detection for Flutter/Dart Commands**:
Before running any `flutter` or `dart` command, automatically detect the environment:

1. **Check if in WSL**: Look for `/mnt/d/` in the current working directory path
2. **If in WSL**: Use Windows Flutter installation via cmd.exe:
   - Replace `flutter` with `cmd.exe /c "D:\SDKs\flutter\bin\flutter.bat"`
   - Replace `dart` with `cmd.exe /c "D:\SDKs\flutter\bin\dart.bat"`
3. **If not in WSL** (macOS/Linux native): Use standard commands:
   - Use `flutter` and `dart` directly

**Detection Methods** (use any of these to determine WSL environment):
- Check if current working directory contains `/mnt/d/` or `/mnt/c/`
- Check if `/proc/version` contains "microsoft" or "WSL"
- Check if environment variable `WSL_DISTRO_NAME` exists
- Prefer the working directory check (`/mnt/d/`) as it's fastest and most reliable for this project

### Development
```bash
# Install dependencies
flutter pub get
# WSL: cmd.exe /c "D:\SDKs\flutter\bin\flutter.bat pub get"

# Run the app (debug mode)
flutter run
# WSL: cmd.exe /c "D:\SDKs\flutter\bin\flutter.bat run"

# Run on specific device/platform
flutter run -d chrome      # Web
flutter run -d android      # Android
flutter run -d ios          # iOS
# WSL: cmd.exe /c "D:\SDKs\flutter\bin\flutter.bat run -d chrome"
```

### Code Generation
```bash
# Generate models/serialization code (required after modifying models or enums)
dart run build_runner build --delete-conflicting-outputs
# WSL: cmd.exe /c "D:\SDKs\flutter\bin\dart.bat run build_runner build --delete-conflicting-outputs"

# Watch for changes and auto-generate
dart run build_runner watch --delete-conflicting-outputs
# WSL: cmd.exe /c "D:\SDKs\flutter\bin\dart.bat run build_runner watch --delete-conflicting-outputs"
```

### Code Quality

**IMPORTANT: When checking for analysis issues, ALWAYS run BOTH commands:**
1. **Standard analysis**: `flutter analyze` - Checks standard Dart/Flutter rules
2. **Custom lint**: `dart run custom_lint` - Checks project-specific custom rules

The project uses custom_lint with additional strict rules beyond the standard analyzer. Running only `flutter analyze` will miss many issues that appear in the IDE.

```bash
# Run tests
flutter test
# WSL: cmd.exe /c "D:\SDKs\flutter\bin\flutter.bat test"

# Run specific test file
flutter test test/path/to/test_file.dart
# WSL: cmd.exe /c "D:\SDKs\flutter\bin\flutter.bat test test/path/to/test_file.dart"

# Analyze code - BOTH COMMANDS REQUIRED FOR COMPLETE ANALYSIS
flutter analyze  # Standard Dart/Flutter analysis
dart run custom_lint  # Project-specific custom rules (MUST RUN THIS TOO!)
# WSL:
# cmd.exe /c "D:\SDKs\flutter\bin\flutter.bat analyze"
# cmd.exe /c "D:\SDKs\flutter\bin\dart.bat run custom_lint"

# Format code
dart format .
# WSL: cmd.exe /c "D:\SDKs\flutter\bin\dart.bat format ."

# Sort imports
dart run import_sorter:main
# WSL: cmd.exe /c "D:\SDKs\flutter\bin\dart.bat run import_sorter:main"
```

### Building
```bash
# Build for production
flutter build apk           # Android APK
flutter build appbundle     # Android App Bundle
flutter build ios           # iOS
flutter build web           # Web
flutter build windows       # Windows
flutter build macos         # macOS
flutter build linux         # Linux
# WSL: cmd.exe /c "D:\SDKs\flutter\bin\flutter.bat build [apk|appbundle|ios|web|windows|macos|linux]"
```

## Architecture

The application follows Clean Architecture with BLoC state management:

### Layer Structure
- **Data Layer** (`lib/src/data/`): Handles external data sources and API communication
  - `repositories/`: Abstract interfaces and concrete implementations for data access
  - `services/`: API clients (IGDB, Twitch auth), notifications, storage services

- **Domain Layer** (`lib/src/domain/`): Business logic and entities
  - `models/`: Core data models (Game, Platform, ReleaseDate, etc.) with JSON serialization
  - `enums/`: Business enums (GameCategory, PlatformFilter, etc.)
  - Uses Freezed for immutable models and JSON serialization

- **Presentation Layer** (`lib/src/presentation/`): UI components and state management
  - Each feature has its own directory with:
    - Main container widget
    - `state/`: Cubit and State classes for BLoC pattern
    - `widgets/`: Feature-specific UI components
  - `common/`: Shared UI components and state

### State Management
- Uses `flutter_bloc` with Cubits for state management
- Each major feature has its own Cubit:
  - `UpcomingGamesCubit`: Manages the main games list with infinite scrolling
  - `RemindersCubit`: Handles user game reminders and notifications
  - `GameDetailCubit`: Manages individual game details view
  - `NotificationsCubit`: Controls notification permissions and scheduling
  - `GameUpdateCubit`: Background game data updates
  - `ThemeCubit`: App theme management

### Dependency Injection
- Uses `GetIt` service locator pattern
- All services and repositories are registered in `main.dart`
- Services are injected into Cubits via constructor

## API Configuration

The app requires IGDB API credentials configured in `env/env.json`:
```json
{
  "twitch_client_id": "your_client_id",
  "twitch_client_secret": "your_client_secret"
}
```

The app uses Twitch OAuth for IGDB API authentication, with token management handled by `TwitchAuthService`.

## Data Persistence

- **Hive**: Local NoSQL database for storing game reminders and bookmarks
  - `game_bookmark_box`: Stores bookmarked games
  - `game_scheduled_box`: Stores scheduled game reminders
- **SharedPreferences**: User preferences (theme, view modes)
- **Flutter Local Notifications**: Scheduled release date reminders

## Key Services

- **IGDBService**: Main interface for fetching game data from IGDB API
- **NotificationService**: Manages local notifications for game releases
- **GameUpdateService**: Background updates for bookmarked games
- **TwitchAuthService**: Handles OAuth token management for IGDB API access

## Testing Approach

Tests are organized in:
- `test/unit/`: Unit tests for services and business logic
- `test/widget/`: Widget tests for UI components
- `test/helpers/`: Test utilities and mocks

Run tests before committing changes to ensure nothing is broken.

## Code Style

- Custom linting rules configured in `analysis_options.yaml` using `custom_lint`
- Key rules include:
  - Always declare return types
  - Cancel subscriptions and close sinks
  - Prefer const constructors and immutables
  - Use package imports consistently
  - Prefer final fields and locals
  - Proper disposal of controllers
  - Proper use of Flutter widgets (Expanded, Flexible, etc.)
- Import sorting enforced via `import_sorter`

### Widget Performance Guidelines

**NEVER use widget-returning methods** - These are rebuilt on every parent rebuild and cause performance issues:

```dart
// ❌ ANTI-PATTERN: Widget-returning methods (performance killer)
class MyWidget extends StatelessWidget {
  Widget _buildCard() {  // This rebuilds unnecessarily
    return Card(...);
  }
}

// ✅ CORRECT: Extract to separate StatelessWidget
class MyCard extends StatelessWidget {  // Only rebuilds when needed
  const MyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(...);
  }
}
```

**Required Structure for extracted widgets:**
- Create separate `.dart` files in a `widgets/` subdirectory
- Follow project folder structure: `feature/widgets/widget_name.dart`
- Use StatelessWidget for better performance
- Pass required data as constructor parameters

**Example: Theme widgets structure**
```
lib/src/presentation/more/widgets/app_theme/
├── app_theme.dart                 # Main theme screen
└── widgets/                       # Extracted widget components
    ├── color_scheme_card.dart     # Individual color selection card
    ├── brightness_option.dart     # Light/dark/system option
    └── color_preview.dart         # Small color circle preview
```
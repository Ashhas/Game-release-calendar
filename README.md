# Game Release Calendar

A comprehensive Flutter mobile application for tracking video game release dates with smart notifications and advanced filtering capabilities.

[![Flutter](https://img.shields.io/badge/Flutter-3.3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.3.0+-blue.svg)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Features

### Core Functionality
- **Comprehensive Game Database**: Browse thousands of games via IGDB (Internet Game Database) API
- **Advanced Search**: Find games by name with intelligent accent-aware matching (e.g., "pokemon" finds "Pokémon")
- **Release Date Tracking**: View games organized chronologically with "TBD" support for unannounced dates
- **Smart Notifications**: Set customizable reminders for game releases with local notifications
- **Advanced Filtering**: Filter by platforms, categories, and release date ranges
- **Detailed Game Information**: View comprehensive game details, platforms, release dates, and cover art

### User Experience
- **Dark/Light Mode**: System-aware theming with manual override
- **Multiple View Modes**: Grid (small/large) and list views for reminders
- **Date Scrollbar**: Quick navigation through release timeline
- **Background Sync**: Automatic updates for bookmarked games
- **Accessibility**: Full screen reader support and semantic labeling
- **Multi-Platform**: Android, iOS, Web, Windows, macOS, and Linux support

## Getting Started

### Prerequisites

- **Flutter SDK**: `>=3.3.0 <4.0.0`
- **Dart SDK**: `>=3.3.0`
- **Android Studio** / **VS Code** with Flutter extensions
- **Xcode** (for iOS development)
- **Git**

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/game-release-calendar.git
   cd game-release-calendar
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment configuration**
   ```bash
   # Create environment configuration file
   cp env/env.json.example env/env.json
   # Edit env/env.json with your API credentials
   ```

4. **Generate code (for models and serialization)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### API Configuration

The app requires IGDB API access via Twitch Developer Console:

1. **Register at [Twitch Developer Console](https://dev.twitch.tv/console)**
2. **Create a new application**
3. **Get your Client ID and Client Secret**
4. **Update `env/env.json`**:
   ```json
   {
     "twitch_client_id": "your_client_id_here",
     "twitch_client_secret": "your_client_secret_here"
   }
   ```

## Architecture

### Project Structure
```
lib/
├── src/
│   ├── app.dart                    # Main app configuration
│   ├── config/                     # Environment & Firebase config
│   ├── data/                       # Data layer
│   │   ├── repositories/           # Repository implementations
│   │   └── services/               # API services
│   ├── domain/                     # Business logic
│   │   ├── models/                 # Data models
│   │   ├── enums/                  # Enumerations
│   │   └── exceptions/             # Custom exceptions
│   ├── presentation/               # UI layer
│   │   ├── upcoming_games/         # Main games list
│   │   ├── reminders/              # User reminders
│   │   ├── game_detail/            # Game details
│   │   ├── more/                   # Settings & info
│   │   └── common/                 # Shared UI components
│   ├── theme/                      # App theming
│   └── utils/                      # Utility classes
└── main.dart
```

### Key Design Patterns

- **Clean Architecture**: Separation of concerns with data, domain, and presentation layers
- **BLoC Pattern**: State management using `flutter_bloc` and Cubits
- **Dependency Injection**: Service locator pattern with GetIt
- **Repository Pattern**: Abstracted data access layer
- **Factory Pattern**: Model creation and serialization
- **Observer Pattern**: Reactive UI updates with streams

## Development

### Essential Commands

```bash
# Install dependencies
flutter pub get

# Run the app (debug mode)
flutter run

# Run tests
flutter test

# Code analysis
flutter analyze

# Format code
dart format .

# Custom lint analysis
dart run custom_lint

# Generate models/serialization
dart run build_runner build --delete-conflicting-outputs

# Import sorting
dart run import_sorter:main
```

### Code Generation

After modifying models or enums, regenerate code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Configuration

### Environment Variables
Create `env/env.json`:
```json
{
  "twitch_client_id": "your_twitch_client_id",
  "twitch_client_secret": "your_twitch_client_secret"
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Roadmap

- [ ] **Social Features**: Share game wishlists with friends
- [ ] **Calendar Integration**: Export to Google Calendar, Apple Calendar
- [ ] **Cloud Sync**: Cross-device synchronization
- [ ] **Widget Support**: Home screen widgets for upcoming releases


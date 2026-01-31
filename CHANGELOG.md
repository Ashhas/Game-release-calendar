# Changelog

All notable changes to GameWatch will be documented in this file.

## [1.1.0] - 2026-01-31

### Added
- GDPR-compliant privacy consent dialog on first launch
- Privacy settings screen with individual toggles
- Firebase Crashlytics for crash reporting (opt-in)
- Ability to enable/disable analytics and crash logs separately
- Adult content filter (hides erotic-themed games by default)
- Content Preferences settings screen with default toggle

### Changed
- PostHog analytics now requires explicit user consent
- Improved debug logging (only visible in debug builds)

### Fixed
- Auth token refresh now uses early return pattern for cleaner code

---

## [1.0.2] - 2025-01-30

### Changed
- Improved app initialization sequence
- Enhanced auth token handling and retry logic
- Automated build number generation

### Fixed
- App stability improvements

---

## [1.0.1] - 2025-01-28

### Added
- Analytics tracking with PostHog
- ProGuard rules for Android release builds

### Changed
- Improved background update reliability
- Updated Flutter version in CI workflows

### Fixed
- Notification scheduling improvements

---

## [1.0.0] - 2025-01-25

### Added
- Track upcoming game releases from IGDB database
- Set reminders for game release dates
- TBD release date sections with filter toggle
- Game update logging and release precision filter
- Search with fuzzy matching
- Dynamic theming with multiple color schemes
- Light/Dark/System theme modes
- Support for Android, iOS, Web, Windows, macOS, and Linux
- App icons for Android & iOS

### Features
- Infinite scrolling game list
- Game detail view with cover art and metadata
- Bookmark favorite games
- Filter by platform, release date precision
- Local notifications for release reminders
- Background game data updates

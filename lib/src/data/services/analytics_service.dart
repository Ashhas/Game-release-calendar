import 'dart:developer' as dev;

import 'package:posthog_flutter/posthog_flutter.dart';

/// Service for tracking analytics events via PostHog.
///
/// Provides typed methods for common events to ensure consistency
/// and make it easy to track what events exist in the app.
///
/// All tracking methods are designed to be non-blocking - errors are caught
/// and logged rather than propagated, ensuring analytics failures never
/// disrupt the user experience.
///
/// Usage:
/// ```dart
/// final analytics = GetIt.instance.get<AnalyticsService>();
/// analytics.trackGameViewed(gameId: 123, gameName: 'Elden Ring');
/// ```
class AnalyticsService {
  const AnalyticsService();

  Posthog get _posthog => Posthog();

  // ============================================================
  // Game Events
  // ============================================================

  /// Track when a user views a game's details
  Future<void> trackGameViewed({
    required int gameId,
    required String gameName,
  }) async {
    await _capture('game_viewed', {
      'game_id': gameId,
      'game_name': gameName,
    });
  }

  /// Track when a user adds a reminder for a game
  Future<void> trackReminderAdded({
    required int gameId,
    required String gameName,
    required int releaseDateId,
    String? releaseDate,
  }) async {
    await _capture('reminder_added', {
      'game_id': gameId,
      'game_name': gameName,
      'release_date_id': releaseDateId,
      if (releaseDate != null) 'release_date': releaseDate,
    });
  }

  /// Track when a user removes a reminder
  Future<void> trackReminderRemoved({
    required int releaseDateId,
  }) async {
    await _capture('reminder_removed', {
      'release_date_id': releaseDateId,
    });
  }

  // ============================================================
  // Search & Filter Events
  // ============================================================

  /// Track when a user performs a search
  Future<void> trackSearchPerformed({
    required String query,
  }) async {
    await _capture('search_performed', {
      'query': query,
      'query_length': query.length,
    });
  }

  /// Track when a user applies filters
  Future<void> trackFilterApplied({
    required List<String> platforms,
    String? dateFilter,
    List<int>? categoryIds,
    String? precisionFilter,
  }) async {
    await _capture('filter_applied', {
      'platforms': platforms,
      'platform_count': platforms.length,
      if (dateFilter != null) 'date_filter': dateFilter,
      if (categoryIds != null) 'category_ids': categoryIds,
      if (precisionFilter != null) 'precision_filter': precisionFilter,
    });
  }

  // ============================================================
  // Theme Events
  // ============================================================

  /// Track when a user changes the color theme.
  ///
  /// Also updates the super property so all future events include the new theme.
  Future<void> trackThemeColorChanged({
    required String colorName,
  }) async {
    try {
      await _posthog.register('theme_color', colorName);
      await _posthog.capture(
        eventName: 'theme_color_changed',
        properties: {'color_name': colorName},
      );
      dev.log('Analytics: theme_color_changed - $colorName');
    } catch (e, stackTrace) {
      dev.log(
        'Analytics error capturing theme_color_changed: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Track when a user changes the brightness mode.
  ///
  /// Also updates the super property so all future events include the new brightness.
  Future<void> trackThemeBrightnessChanged({
    required String brightnessMode,
  }) async {
    try {
      await _posthog.register('theme_brightness', brightnessMode);
      await _posthog.capture(
        eventName: 'theme_brightness_changed',
        properties: {'brightness_mode': brightnessMode},
      );
      dev.log('Analytics: theme_brightness_changed - $brightnessMode');
    } catch (e, stackTrace) {
      dev.log(
        'Analytics error capturing theme_brightness_changed: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ============================================================
  // Screen Events
  // ============================================================

  /// Track screen views for understanding user navigation patterns.
  ///
  /// Call this in widget initState or when navigating to a new screen.
  Future<void> trackScreenViewed({
    required String screenName,
    Map<String, Object>? properties,
  }) async {
    try {
      await _posthog.screen(
        screenName: screenName,
        properties: properties,
      );
      dev.log('Analytics: screen_viewed - $screenName');
    } catch (e, stackTrace) {
      dev.log(
        'Analytics error tracking screen $screenName: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ============================================================
  // Error Events
  // ============================================================

  /// Track errors for debugging and monitoring application health.
  ///
  /// Use this for caught exceptions that should be monitored but don't
  /// crash the app.
  ///
  /// Parameters:
  /// - [errorType]: Category of error (e.g., 'network', 'parse', 'state')
  /// - [errorMessage]: Human-readable description of what went wrong
  /// - [stackTrace]: Optional stack trace for debugging
  /// - [context]: Additional context like affected screen or user action
  Future<void> trackError({
    required String errorType,
    required String errorMessage,
    String? stackTrace,
    Map<String, dynamic>? context,
  }) async {
    await _capture('error_occurred', {
      'error_type': errorType,
      'error_message': errorMessage,
      if (stackTrace != null) 'stack_trace': stackTrace,
      if (context != null) ...context,
    });
  }

  // ============================================================
  // Private Helpers
  // ============================================================

  /// Captures an event with the given name and properties.
  ///
  /// Errors are caught and logged rather than propagated to ensure
  /// analytics failures never disrupt the user experience.
  Future<void> _capture(String eventName, Map<String, Object?> properties) async {
    try {
      // Filter out null values as PostHog expects Map<String, Object>
      final filteredProperties = Map<String, Object>.fromEntries(
        properties.entries.where((e) => e.value != null).map(
          (e) => MapEntry(e.key, e.value!),
        ),
      );

      await _posthog.capture(
        eventName: eventName,
        properties: filteredProperties,
      );
      dev.log('Analytics: $eventName - $filteredProperties');
    } catch (e, stackTrace) {
      dev.log(
        'Analytics error capturing $eventName: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}

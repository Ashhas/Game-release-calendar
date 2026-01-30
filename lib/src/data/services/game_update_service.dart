import 'dart:developer' as developer;

import 'package:hive_ce/hive.dart';

import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/domain/models/game_update_log.dart';
import 'package:game_release_calendar/src/domain/enums/game_update_type.dart';
import 'package:game_release_calendar/src/domain/enums/game_status.dart';
import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:game_release_calendar/src/utils/date_utilities.dart';

class GameUpdateService {
  final IGDBRepository igdbRepository;
  final Box<GameReminder> gameRemindersBox;
  final NotificationClient notificationClient;
  final Box<GameUpdateLog> gameUpdateLogBox;

  const GameUpdateService({
    required this.igdbRepository,
    required this.gameRemindersBox,
    required this.notificationClient,
    required this.gameUpdateLogBox,
  });

  /// Checks all bookmarked games for updates and refreshes their data
  Future<void> checkAndUpdateBookmarkedGames() async {
    await checkAndUpdateBookmarkedGamesWithProgress();
  }

  /// Checks all bookmarked games for updates with progress tracking
  Future<bool> checkAndUpdateBookmarkedGamesWithProgress({
    Function(int total, int processed)? onProgress,
  }) async {
    try {

      final gameReminders = gameRemindersBox.values.toList();

      if (gameReminders.isEmpty) {
        return false;
      }

      bool hasUpdates = false;

      // Extract unique games from reminders
      final uniqueGames = <int, Game>{};
      for (final reminder in gameReminders) {
        uniqueGames[reminder.gameId] = reminder.gamePayload;
      }
      final bookmarkedGames = uniqueGames.values.toList();


      // Process games in batches to avoid overwhelming the API
      const batchSize = 5; // Smaller batches for better progress tracking
      int processedCount = 0;

      onProgress?.call(bookmarkedGames.length, 0);

      for (int i = 0; i < bookmarkedGames.length; i += batchSize) {
        final batch = bookmarkedGames.skip(i).take(batchSize).toList();


        final batchHasUpdates = await _processBatchWithProgress(batch);
        if (batchHasUpdates) hasUpdates = true;

        processedCount += batch.length;
        onProgress?.call(bookmarkedGames.length, processedCount);


        // Small delay between batches and yield to allow UI updates
        if (i + batchSize < bookmarkedGames.length) {
          await Future.delayed(const Duration(milliseconds: 300));
          // Yield control back to the UI thread
          await Future.delayed(Duration.zero);
        }
      }

      return hasUpdates;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _processBatchWithProgress(
    List<Game> games,
  ) async {
    bool batchHasUpdates = false;
    final gameIds = games.map((game) => game.id).join(',');

    try {
      // Build query to fetch updated game data
      final query = 'where id = ($gameIds); '
          'fields *, platforms.*, cover.*, release_dates.*, artworks.*, category; '
          'limit ${games.length};';


      final updatedGames = await igdbRepository.getGames(query);


      if (updatedGames.length != games.length) {
      }

      for (int i = 0; i < updatedGames.length; i++) {
        final updatedGame = updatedGames[i];
        final existingGame = games.firstWhere(
          (game) => game.id == updatedGame.id,
        );

        final gameHasUpdates =
            await _processGameUpdate(existingGame, updatedGame);
        if (gameHasUpdates) batchHasUpdates = true;

        // Yield control periodically during processing
        if (i % 2 == 0) {
          await Future.delayed(Duration.zero);
        }
      }
    } catch (e) {
      rethrow;
    }
    return batchHasUpdates;
  }

  Future<bool> _processGameUpdate(Game existingGame, Game updatedGame) async {
    try {
      // Check if the game data has been updated (with logging)
      final hasDataChanged = await _hasGameDataChangedWithLogging(existingGame, updatedGame);
      final hasReleaseDateChanged =
          await _hasReleaseDateChangedWithLogging(existingGame, updatedGame);

      if (!hasDataChanged && !hasReleaseDateChanged) {
        return false; // No changes detected
      }


      if (hasDataChanged) {
        // Update the bookmarked game with new data
        await _updateBookmarkedGame(existingGame, updatedGame);
      }

      if (hasReleaseDateChanged) {
        // Handle release date changes and notification updates
        await _handleReleaseDateChange(existingGame, updatedGame);
      }

      return true; // Changes were detected and processed
    } catch (e) {
      return false; // Error occurred, treat as no updates
    }
  }


  Future<void> _updateBookmarkedGame(
      Game existingGame, Game updatedGame) async {
    try {
      // Update all reminders that reference this game
      final remindersToUpdate = gameRemindersBox.values
          .where((reminder) => reminder.gameId == existingGame.id)
          .toList();


      for (final reminder in remindersToUpdate) {
        // Find the key for this reminder
        final reminderKey = gameRemindersBox.keys.firstWhere(
          (key) => gameRemindersBox.get(key)?.id == reminder.id,
        );

        // Create updated reminder with new game payload
        final updatedReminder = GameReminder(
          id: reminder.id,
          gameId: reminder.gameId,
          gameName: updatedGame.name,
          gamePayload: updatedGame,
          releaseDate: reminder.releaseDate,
          releaseDateCategory: reminder.releaseDateCategory,
          notificationDate: reminder.notificationDate,
        );

        // Update the reminder in the box
        await gameRemindersBox.put(reminderKey, updatedReminder);
      }

    } catch (e, stackTrace) {
      developer.log(
        'Error updating bookmarked game ${existingGame.id}',
        error: e,
        stackTrace: stackTrace,
        name: 'GameUpdateService',
      );
    }
  }

  Future<void> _handleReleaseDateChange(
      Game existingGame, Game updatedGame) async {
    try {
      // Find all reminders for this game
      final gameReminders = gameRemindersBox.values
          .where((reminder) => reminder.gameId == existingGame.id)
          .toList();

      if (gameReminders.isEmpty) {
        return; // No reminders to update
      }


      for (final reminder in gameReminders) {
        await _updateGameReminder(reminder, updatedGame);
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error handling release date change for game ${existingGame.id}',
        error: e,
        stackTrace: stackTrace,
        name: 'GameUpdateService',
      );
    }
  }

  Future<void> _updateGameReminder(
      GameReminder existingReminder, Game updatedGame) async {
    try {
      // Find the corresponding release date in the updated game
      final updatedReleaseDate = updatedGame.releaseDates?.firstWhere(
        (date) => date.id == existingReminder.releaseDate.id,
        orElse: () => existingReminder.releaseDate,
      );

      if (updatedReleaseDate == null) {
        // Release date no longer exists, remove the reminder
        await _removeGameReminder(existingReminder);
        return;
      }

      // Check if the release date actually changed
      if (existingReminder.releaseDate.date == updatedReleaseDate.date) {
        // Just update the game payload but keep the same notification
        final updatedReminder = GameReminder(
          id: existingReminder.id,
          gameId: existingReminder.gameId,
          gameName: updatedGame.name,
          gamePayload: updatedGame,
          releaseDate: updatedReleaseDate,
          releaseDateCategory: existingReminder.releaseDateCategory,
          notificationDate: existingReminder.notificationDate,
        );

        await _saveUpdatedReminder(existingReminder, updatedReminder);
        return;
      }

      // Release date changed, need to reschedule notification
      await _rescheduleNotification(
          existingReminder, updatedGame, updatedReleaseDate);
    } catch (e, stackTrace) {
      developer.log(
        'Error updating game reminder ${existingReminder.id}',
        error: e,
        stackTrace: stackTrace,
        name: 'GameUpdateService',
      );
    }
  }

  Future<void> _rescheduleNotification(
    GameReminder existingReminder,
    Game updatedGame,
    ReleaseDate updatedReleaseDate,
  ) async {
    try {
      // Cancel the existing notification
      await notificationClient
          .cancelNotification(existingReminder.releaseDate.id);

      // Schedule new notification with updated release date
      await notificationClient.scheduleNotificationFromGame(
        game: updatedGame,
        releaseDate: updatedReleaseDate,
      );

      // Create updated reminder with new notification date
      final newNotificationDate = _computeNotificationDate(updatedReleaseDate);
      final updatedReminder = GameReminder(
        id: existingReminder.id,
        gameId: existingReminder.gameId,
        gameName: updatedGame.name,
        gamePayload: updatedGame,
        releaseDate: updatedReleaseDate,
        releaseDateCategory: existingReminder.releaseDateCategory,
        notificationDate: newNotificationDate,
      );

      await _saveUpdatedReminder(existingReminder, updatedReminder);

    } catch (e, stackTrace) {
      developer.log(
        'Error rescheduling notification for reminder ${existingReminder.id}',
        error: e,
        stackTrace: stackTrace,
        name: 'GameUpdateService',
      );
    }
  }

  Future<void> _saveUpdatedReminder(
      GameReminder existingReminder, GameReminder updatedReminder) async {
    try {
      // Find the key for the existing reminder in the box
      final reminderKey = gameRemindersBox.keys.firstWhere(
        (key) => gameRemindersBox.get(key)?.id == existingReminder.id,
      );

      // Update the reminder in the box
      await gameRemindersBox.put(reminderKey, updatedReminder);

    } catch (e, stackTrace) {
      developer.log(
        'Error saving updated reminder ${existingReminder.id}',
        error: e,
        stackTrace: stackTrace,
        name: 'GameUpdateService',
      );
    }
  }

  Future<void> _removeGameReminder(GameReminder reminder) async {
    try {
      // Cancel the notification
      await notificationClient.cancelNotification(reminder.releaseDate.id);

      // Find and remove the reminder from the box
      final reminderKey = gameRemindersBox.keys.firstWhere(
        (key) => gameRemindersBox.get(key)?.id == reminder.id,
      );

      await gameRemindersBox.delete(reminderKey);

    } catch (e, stackTrace) {
      developer.log(
        'Error removing game reminder ${reminder.id}',
        error: e,
        stackTrace: stackTrace,
        name: 'GameUpdateService',
      );
    }
  }

  DateTime? _computeNotificationDate(ReleaseDate releaseDate) {
    if (releaseDate.date == null) return null;
    return DateUtilities.computeNotificationDate(releaseDate.date!);
  }

  /// Logs a game update to persistent storage
  Future<void> _logGameUpdate({
    required Game updatedGame,
    required GameUpdateType updateType,
    String? oldValue,
    String? newValue,
  }) async {
    try {
      final updateLog = GameUpdateLog.create(
        gameId: updatedGame.id,
        gameName: updatedGame.name,
        gamePayload: updatedGame,
        updateType: updateType,
        oldValue: oldValue,
        newValue: newValue,
      );

      await gameUpdateLogBox.add(updateLog);

      // Clean up old logs to prevent storage bloat (keep last 1000 entries)
      if (gameUpdateLogBox.length > 1000) {
        final keysToDelete = gameUpdateLogBox.keys.take(gameUpdateLogBox.length - 1000);
        for (final key in keysToDelete) {
          await gameUpdateLogBox.delete(key);
        }
      }
    } catch (e, stackTrace) {
      // Log error but don't fail the update process
      developer.log(
        'Error logging game update',
        error: e,
        stackTrace: stackTrace,
        name: 'GameUpdateService',
      );
    }
  }

  /// Enhanced game data comparison with logging
  Future<bool> _hasGameDataChangedWithLogging(Game existingGame, Game updatedGame) async {
    bool hasLoggedChanges = false;

    // Only log changes users care about: title, cover, platforms, status
    if (existingGame.name != updatedGame.name) {
      await _logGameUpdate(
        updatedGame: updatedGame,
        updateType: GameUpdateType.gameInfo,
        oldValue: existingGame.name,
        newValue: updatedGame.name,
      );
      hasLoggedChanges = true;
    }

    if (existingGame.cover?.url != updatedGame.cover?.url) {
      await _logGameUpdate(
        updatedGame: updatedGame,
        updateType: GameUpdateType.coverImage,
        oldValue: existingGame.cover?.url,
        newValue: updatedGame.cover?.url,
      );
      hasLoggedChanges = true;
    }

    // Check platform changes
    final existingPlatformIds = existingGame.platforms?.map((p) => p.id).toSet() ?? <int>{};
    final updatedPlatformIds = updatedGame.platforms?.map((p) => p.id).toSet() ?? <int>{};

    if (!existingPlatformIds.containsAll(updatedPlatformIds) ||
        !updatedPlatformIds.containsAll(existingPlatformIds)) {
      final existingNames = existingGame.platforms?.map((p) => p.name).join(', ') ?? 'None';
      final updatedNames = updatedGame.platforms?.map((p) => p.name).join(', ') ?? 'None';

      await _logGameUpdate(
        updatedGame: updatedGame,
        updateType: GameUpdateType.platforms,
        oldValue: existingNames,
        newValue: updatedNames,
      );
      hasLoggedChanges = true;
    }

    // Check status changes with readable text
    if (existingGame.status != updatedGame.status) {
      final oldStatusText = GameStatus.getStatusText(existingGame.status);
      final newStatusText = GameStatus.getStatusText(updatedGame.status);

      await _logGameUpdate(
        updatedGame: updatedGame,
        updateType: GameUpdateType.status,
        oldValue: oldStatusText,
        newValue: newStatusText,
      );
      hasLoggedChanges = true;
    }

    // Use checksum internally for detection but don't log it
    final hasInternalChanges = existingGame.updatedAt != updatedGame.updatedAt ||
        existingGame.checksum != updatedGame.checksum ||
        existingGame.name != updatedGame.name ||
        existingGame.cover?.url != updatedGame.cover?.url ||
        existingGame.status != updatedGame.status ||
        !existingPlatformIds.containsAll(updatedPlatformIds) ||
        !updatedPlatformIds.containsAll(existingPlatformIds);

    return hasLoggedChanges || hasInternalChanges;
  }

  /// Enhanced release date comparison with logging
  Future<bool> _hasReleaseDateChangedWithLogging(Game existingGame, Game updatedGame) async {
    bool hasChanges = false;

    // Check first release date
    if (existingGame.firstReleaseDate != updatedGame.firstReleaseDate) {
      await _logGameUpdate(
        updatedGame: updatedGame,
        updateType: GameUpdateType.releaseDate,
        oldValue: existingGame.firstReleaseDate?.toString(),
        newValue: updatedGame.firstReleaseDate?.toString(),
      );
      hasChanges = true;
    }

    // Check release dates lists
    final existingDates = existingGame.releaseDates ?? [];
    final updatedDates = updatedGame.releaseDates ?? [];

    if (existingDates.length != updatedDates.length) {
      await _logGameUpdate(
        updatedGame: updatedGame,
        updateType: GameUpdateType.releaseDate,
        oldValue: '${existingDates.length} dates',
        newValue: '${updatedDates.length} dates',
      );
      hasChanges = true;
    }

    // Check if any release date has changed
    for (int i = 0; i < existingDates.length; i++) {
      final existingDate = existingDates[i];
      final updatedDate = updatedDates.firstWhere(
        (date) => date.id == existingDate.id,
        orElse: () => existingDate,
      );

      if (existingDate.date != updatedDate.date ||
          existingDate.human != updatedDate.human ||
          existingDate.category != updatedDate.category) {
        hasChanges = true;
        break;
      }
    }

    return hasChanges;
  }

}

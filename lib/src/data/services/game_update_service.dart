import 'dart:developer';

import 'package:hive/hive.dart';

import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:game_release_calendar/src/utils/date_time_converter.dart';

class GameUpdateService {
  final IGDBRepository igdbRepository;
  final Box<GameReminder> gameRemindersBox;
  final NotificationClient notificationClient;

  const GameUpdateService({
    required this.igdbRepository,
    required this.gameRemindersBox,
    required this.notificationClient,
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
      log('🔄 Starting bookmark update check...');
      
      final gameReminders = gameRemindersBox.values.toList();
      
      if (gameReminders.isEmpty) {
        log('❌ No bookmarked games to update - reminders box is empty');
        onProgress?.call(0, 0);
        return false;
      }
      
      bool hasUpdates = false;

      // Extract unique games from reminders
      final uniqueGames = <int, Game>{};
      for (final reminder in gameReminders) {
        uniqueGames[reminder.gameId] = reminder.gamePayload;
      }
      final bookmarkedGames = uniqueGames.values.toList();

      log('✅ Found ${bookmarkedGames.length} unique bookmarked games to check for updates');
      for (final game in bookmarkedGames) {
        log('   📋 Game: ${game.name} (ID: ${game.id})');
      }
      
      // Process games in batches to avoid overwhelming the API
      const batchSize = 5; // Smaller batches for better progress tracking
      int processedCount = 0;
      
      onProgress?.call(bookmarkedGames.length, 0);
      
      for (int i = 0; i < bookmarkedGames.length; i += batchSize) {
        final batch = bookmarkedGames.skip(i).take(batchSize).toList();
        final batchNumber = (i ~/ batchSize) + 1;
        final totalBatches = (bookmarkedGames.length / batchSize).ceil();
        
        log('🔍 Processing batch $batchNumber/$totalBatches (${batch.length} games)');
        for (final game in batch) {
          log('   🎮 Checking: ${game.name}');
        }
        
        final batchHasUpdates = await _processBatchWithProgress(batch, onProgress, processedCount, bookmarkedGames.length);
        if (batchHasUpdates) hasUpdates = true;
        
        processedCount += batch.length;
        onProgress?.call(bookmarkedGames.length, processedCount);
        
        log('✅ Completed batch $batchNumber/$totalBatches - processed $processedCount/${bookmarkedGames.length} games');
        
        // Small delay between batches and yield to allow UI updates
        if (i + batchSize < bookmarkedGames.length) {
          log('⏳ Waiting 300ms before next batch...');
          await Future.delayed(const Duration(milliseconds: 300));
          // Yield control back to the UI thread
          await Future.delayed(Duration.zero);
        }
      }
      
      log('🎉 Completed bookmark update check - processed ${bookmarkedGames.length} games total');
      log(hasUpdates ? '✨ Updates were found and applied!' : '✅ No updates needed - all games are current');
      return hasUpdates;
    } catch (e) {
      log('Error during bookmark update check: $e');
      rethrow;
    }
  }


  Future<bool> _processBatchWithProgress(
    List<Game> games, 
    Function(int total, int processed)? onProgress,
    int currentProcessed,
    int totalGames,
  ) async {
    bool batchHasUpdates = false;
    final gameIds = games.map((game) => game.id).join(',');
    
    try {
      // Build query to fetch updated game data
      final query = 'where id = ($gameIds); '
          'fields *, platforms.*, cover.*, release_dates.*, artworks.*, category; '
          'limit ${games.length};';
      
      log('🌐 Fetching updated data from IGDB API for ${games.length} games...');
      log('   📡 Query: $query');
      
      final updatedGames = await igdbRepository.getGames(query);
      
      log('📥 Received ${updatedGames.length} game updates from IGDB API');
      
      if (updatedGames.length != games.length) {
        log('⚠️  Warning: Expected ${games.length} games but received ${updatedGames.length}');
      }
      
      for (int i = 0; i < updatedGames.length; i++) {
        final updatedGame = updatedGames[i];
        final existingGame = games.firstWhere(
          (game) => game.id == updatedGame.id,
        );
        
        final gameHasUpdates = await _processGameUpdate(existingGame, updatedGame);
        if (gameHasUpdates) batchHasUpdates = true;
        
        // Yield control periodically during processing
        if (i % 2 == 0) {
          await Future.delayed(Duration.zero);
        }
      }
    } catch (e) {
      log('❌ Error processing batch: $e');
      rethrow;
    }
    return batchHasUpdates;
  }

  Future<bool> _processGameUpdate(Game existingGame, Game updatedGame) async {
    try {
      // Check if the game data has been updated
      final hasDataChanged = _hasGameDataChanged(existingGame, updatedGame);
      final hasReleaseDateChanged = _hasReleaseDateChanged(existingGame, updatedGame);
      
      if (!hasDataChanged && !hasReleaseDateChanged) {
        return false; // No changes detected
      }
      
      log('🔄 Detected changes for game: ${updatedGame.name}');
      
      if (hasDataChanged) {
        log('   📝 Updating game data...');
        // Update the bookmarked game with new data
        await _updateBookmarkedGame(existingGame, updatedGame);
      }
      
      if (hasReleaseDateChanged) {
        log('   📅 Handling release date changes...');
        // Handle release date changes and notification updates
        await _handleReleaseDateChange(existingGame, updatedGame);
      }
      
      return true; // Changes were detected and processed
    } catch (e) {
      log('❌ Error processing game update for ${existingGame.name}: $e');
      return false; // Error occurred, treat as no updates
    }
  }

  bool _hasGameDataChanged(Game existingGame, Game updatedGame) {
    // Compare key fields that indicate the game data has been updated
    return existingGame.updatedAt != updatedGame.updatedAt ||
        existingGame.checksum != updatedGame.checksum ||
        existingGame.name != updatedGame.name ||
        existingGame.description != updatedGame.description ||
        existingGame.status != updatedGame.status;
  }

  bool _hasReleaseDateChanged(Game existingGame, Game updatedGame) {
    // Compare first release date
    if (existingGame.firstReleaseDate != updatedGame.firstReleaseDate) {
      return true;
    }
    
    // Compare release dates lists
    final existingDates = existingGame.releaseDates ?? [];
    final updatedDates = updatedGame.releaseDates ?? [];
    
    if (existingDates.length != updatedDates.length) {
      return true;
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
        return true;
      }
    }
    
    return false;
  }

  Future<void> _updateBookmarkedGame(Game existingGame, Game updatedGame) async {
    try {
      log('   🔍 Finding reminders to update for game: ${existingGame.name}');
      // Update all reminders that reference this game
      final remindersToUpdate = gameRemindersBox.values
          .where((reminder) => reminder.gameId == existingGame.id)
          .toList();
      
      log('   📋 Found ${remindersToUpdate.length} reminders to update');
      
      for (final reminder in remindersToUpdate) {
        log('      🔄 Updating reminder ID: ${reminder.id}');
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
        log('      ✅ Updated reminder ID: ${reminder.id}');
      }
      
      log('   ✅ Updated ${remindersToUpdate.length} reminders for game: ${updatedGame.name}');
    } catch (e) {
      log('   ❌ Error updating bookmarked game ${existingGame.name}: $e');
    }
  }

  Future<void> _handleReleaseDateChange(Game existingGame, Game updatedGame) async {
    try {
      log('   🔍 Finding reminders for release date changes: ${existingGame.name}');
      // Find all reminders for this game
      final gameReminders = gameRemindersBox.values
          .where((reminder) => reminder.gameId == existingGame.id)
          .toList();
      
      if (gameReminders.isEmpty) {
        log('   ❌ No reminders found to update for release date changes');
        return; // No reminders to update
      }
      
      log('   📅 Found ${gameReminders.length} reminders to check for release date changes');
      
      for (final reminder in gameReminders) {
        log('      🔄 Processing reminder ID: ${reminder.id} for release date: ${reminder.releaseDate.id}');
        await _updateGameReminder(reminder, updatedGame);
      }
      
    } catch (e) {
      log('   ❌ Error handling release date change for ${existingGame.name}: $e');
    }
  }

  Future<void> _updateGameReminder(GameReminder existingReminder, Game updatedGame) async {
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
      await _rescheduleNotification(existingReminder, updatedGame, updatedReleaseDate);
      
    } catch (e) {
      log('Error updating game reminder for ${existingReminder.gameName}: $e');
    }
  }

  Future<void> _rescheduleNotification(
    GameReminder existingReminder,
    Game updatedGame,
    ReleaseDate updatedReleaseDate,
  ) async {
    try {
      // Cancel the existing notification
      await notificationClient.cancelNotification(existingReminder.releaseDate.id);
      
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
      
      log('Rescheduled notification for ${updatedGame.name}');
    } catch (e) {
      log('Error rescheduling notification for ${existingReminder.gameName}: $e');
    }
  }

  Future<void> _saveUpdatedReminder(GameReminder existingReminder, GameReminder updatedReminder) async {
    try {
      // Find the key for the existing reminder in the box
      final reminderKey = gameRemindersBox.keys.firstWhere(
        (key) => gameRemindersBox.get(key)?.id == existingReminder.id,
      );
      
      // Update the reminder in the box
      await gameRemindersBox.put(reminderKey, updatedReminder);
      
      log('Updated reminder for: ${updatedReminder.gameName}');
    } catch (e) {
      log('Error saving updated reminder: $e');
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
      
      log('Removed outdated reminder for: ${reminder.gameName}');
    } catch (e) {
      log('Error removing game reminder: $e');
    }
  }

  DateTime? _computeNotificationDate(ReleaseDate releaseDate) {
    if (releaseDate.date == null) return null;
    return DateTimeConverter.computeNotificationDate(releaseDate.date!);
  }
}
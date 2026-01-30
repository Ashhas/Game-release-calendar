import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:game_release_calendar/src/data/services/game_update_service.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/theme/app_theme_preset.dart';

class FakeSharedPrefsService implements SharedPrefsService {
  @override
  bool getScrollbarEnabled() => true;
  
  @override
  AppThemePreset getThemePreset() => AppThemePreset.system;
  
  @override
  bool getExperimentalFeaturesEnabled() => false;
  
  @override
  // ignore: avoid_dynamic
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeIGDBService implements IGDBService {
  @override
  // ignore: avoid_dynamic
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeNotificationClient implements NotificationClient {
  @override
  Future<List<PendingNotificationRequest>> retrievePendingNotifications() async => [];
  
  @override
  // ignore: avoid_dynamic
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeGameUpdateService implements GameUpdateService {
  void startBackgroundUpdate() {}
  
  @override
  // ignore: avoid_dynamic
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeBox<T> implements Box<T> {
  @override
  Iterable<T> get values => <T>[];
  
  @override
  // ignore: avoid_dynamic
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakePackageInfo implements PackageInfo {
  @override
  String get appName => 'Test App';
  
  @override
  String get version => '1.0.0';
  
  @override
  String get packageName => 'com.test.app';
  
  @override
  String get buildNumber => '1';
  
  @override
  String get buildSignature => 'test-signature';
  
  @override
  String? get installerStore => null;
  
  @override
  // ignore: avoid_dynamic
  dynamic noSuchMethod(Invocation invocation) => null;
}

class FakeFlutterLocalNotificationsPlugin implements FlutterLocalNotificationsPlugin {
  @override
  // ignore: avoid_dynamic
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Sets up GetIt with fake services for testing
void setupTestDependencies() {
  GetIt.instance.reset();
  
  // Register all required dependencies
  GetIt.instance.registerSingleton<SharedPrefsService>(FakeSharedPrefsService());
  GetIt.instance.registerSingleton<IGDBService>(FakeIGDBService());
  GetIt.instance.registerSingleton<NotificationClient>(FakeNotificationClient());
  GetIt.instance.registerSingleton<GameUpdateService>(FakeGameUpdateService());
  GetIt.instance.registerSingleton<Box<GameReminder>>(FakeBox<GameReminder>());
  GetIt.instance.registerSingleton<Box<Game>>(FakeBox<Game>());
  GetIt.instance.registerSingleton<PackageInfo>(FakePackageInfo());
  GetIt.instance.registerSingleton<FlutterLocalNotificationsPlugin>(FakeFlutterLocalNotificationsPlugin());
}

/// Cleans up GetIt after tests
void tearDownTestDependencies() {
  GetIt.instance.reset();
}
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper class for managing battery optimization settings on Android.
///
/// Android aggressively kills background apps to save battery, which can
/// prevent scheduled notifications from being delivered. This helper provides
/// methods to check and request exemption from battery optimization.
class BatteryOptimizationHelper {
  static const String _hasPromptedKey = 'battery_optimization_prompted';
  static const String _userDeclinedKey = 'battery_optimization_declined';

  /// Checks if the app is currently exempt from battery optimization.
  ///
  /// Returns `true` if:
  /// - The platform is not Android (iOS doesn't have this restriction)
  /// - The app is already exempt from battery optimization
  ///
  /// Returns `false` if:
  /// - The app is subject to battery optimization (notifications may be unreliable)
  static Future<bool> isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final status = await Permission.ignoreBatteryOptimizations.status;
    return status.isGranted;
  }

  /// Requests exemption from battery optimization.
  ///
  /// This will show a system dialog asking the user to allow the app
  /// to run in the background without restrictions.
  ///
  /// Returns `true` if the permission was granted, `false` otherwise.
  static Future<bool> requestBatteryOptimizationExemption() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final status = await Permission.ignoreBatteryOptimizations.request();
    return status.isGranted;
  }

  /// Shows the system dialog to request battery optimization exemption for this app.
  /// Returns `true` if permission was granted.
  static Future<bool> showBatteryOptimizationDialog() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final status = await Permission.ignoreBatteryOptimizations.request();
    return status.isGranted;
  }

  /// Checks if we've already prompted the user about battery optimization.
  static Future<bool> hasPromptedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasPromptedKey) ?? false;
  }

  /// Marks that we've prompted the user about battery optimization.
  static Future<void> setHasPromptedUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasPromptedKey, true);
  }

  /// Resets the prompt flag (useful for testing or settings).
  static Future<void> resetPromptFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasPromptedKey);
  }

  /// Checks if the user has explicitly declined the battery optimization.
  static Future<bool> hasUserDeclinedOptimization() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_userDeclinedKey) ?? false;
  }

  /// Marks that the user has declined the battery optimization.
  /// This will prevent the dialog from showing again.
  static Future<void> setUserDeclinedOptimization() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userDeclinedKey, true);
  }

  /// Resets the user's decline choice (useful for settings to re-enable prompts).
  static Future<void> resetUserDeclinedChoice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDeclinedKey);
    await prefs.remove(_hasPromptedKey);
  }
}

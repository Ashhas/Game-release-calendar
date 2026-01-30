import 'package:flutter/foundation.dart';

import 'package:url_launcher/url_launcher.dart';

/// Helper class for launching URLs and handling various URI schemes.
class UrlHelper {
  /// Opens a URL string. Returns true if successful, false otherwise.
  static Future<bool> openUrl(String url) async {
    return launchUri(Uri.parse(url));
  }

  /// Launches a URI. Returns true if successful, false otherwise.
  ///
  /// For mailto links, tries to launch directly first (works better on some
  /// devices where canLaunchUrl returns false but launchUrl works).
  static Future<bool> launchUri(Uri uri) async {
    try {
      // For mailto, try launching directly first - canLaunchUrl can return
      // false on some devices even when an email app is available
      if (uri.scheme == 'mailto') {
        final launched = await launchUrl(uri);
        if (launched) return true;
      }

      // Standard flow for other URLs or if direct mailto launch failed
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }

      debugPrint('UrlHelper: Cannot launch $uri - no handler available');
      return false;
    } catch (e) {
      debugPrint('UrlHelper: Failed to launch $uri - $e');
      return false;
    }
  }
}

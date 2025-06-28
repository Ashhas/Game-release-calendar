import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<void> openUrl(String url) async {
    await launchUri(Uri.parse(url));
  }

  static Future<void> launchUri(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}

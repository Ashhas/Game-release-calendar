part of '../more_container.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  void initState() {
    super.initState();
    GetIt.instance.get<AnalyticsService>().trackScreenViewed(
      screenName: 'PrivacyPolicy',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacings.m),
        child: Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              WidgetSpan(child: SizedBox(height: context.spacings.m)),
              TextSpan(
                text: 'Introduction\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text:
                    'Welcome to GameWatch! This app allows users to track game release dates and get notified when a game has been released. We are committed to protecting your privacy and ensuring a safe experience while using our app. This privacy policy outlines how we collect, use, store, and protect your information.\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '1. Information We Collect\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: 'Types of Information Collected:\n'
                    '- GameWatch collects the games you want to track. We do not collect any personal information such as your name, email address, phone number, or location data.\n\n'
                    'How Information is Collected:\n'
                    '- The information about the games you want to track is collected when you click/select the games within the app.\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '2. Use of Information\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: 'Purpose of Information Usage:\n'
                    '- The information collected is used solely to enhance your user experience by allowing you to track game release dates and receive notifications when a game has been released.\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '3. Third-Party Services\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: 'IGDB (Internet Game Database):\n'
                    '- Game information is retrieved from IGDB via Twitch API. No personal data is shared with these services.\n'
                    '- IGDB\'s privacy policy: https://www.igdb.com/privacy_policy\n\n'
                    'Firebase Services:\n'
                    '- We use Firebase Crashlytics to collect crash reports and improve app stability.\n'
                    '- We use Firebase Analytics to understand app usage patterns.\n'
                    '- This data is anonymous and used only for app improvement.\n'
                    '- Google\'s privacy policy: https://policies.google.com/privacy\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '4. Data Sharing\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text:
                    '- We do not sell, trade, or share your personal information with third parties for marketing purposes.\n'
                    '- Anonymous crash and analytics data may be shared with Firebase for app improvement.\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '5. Data Storage and Security\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: 'Data Storage:\n'
                    '- Game tracking data is stored locally on your device using Hive database.\n'
                    '- No personal data is stored on external servers.\n\n'
                    'Security Measures:\n'
                    '- Local data is secured within your device\'s app sandbox.\n'
                    '- Crash reports are anonymized before transmission to Firebase.\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '6. User Rights\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: 'Your Rights:\n'
                    '- You have the right to choose which games you want to track and can remove any game from your tracked list at any time.\n'
                    '- You can delete all app data by uninstalling the app.\n\n'
                    'Exercising Your Rights:\n'
                    '- You can manage your tracked games by going to the game details section within the app and using the provided actions to add or remove games.\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '7. Changes to the Privacy Policy\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text:
                    '- Any changes to this privacy policy will be communicated to users through app updates. We encourage you to review the policy periodically for any updates.\n'
                    '- Last updated: January 2025\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '8. Contact Information\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text:
                    '- If you have any questions or concerns about this privacy policy, please contact us at: ashhas.studio@gmail.com\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

part of '../more_container.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
            style: const TextStyle(color: Colors.white, fontSize: 16),
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
                text: '3. Data Sharing\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text:
                    '- GameWatch does not share the collected information with any third parties.\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '4. Data Storage and Security\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: 'Data Storage:\n'
                    '- The information about the games you track is stored locally on your device.\n\n'
                    'Security Measures:\n'
                    '- Since the data is stored locally and not shared online, it remains secure within your device.\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '5. User Rights\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text: 'Your Rights:\n'
                    '- You have the right to choose which games you want to track and can remove any game from your tracked list at any time.\n\n'
                    'Exercising Your Rights:\n'
                    '- You can manage your tracked games by going to the game details section within the app and using the provided actions to add or remove games.\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '6. Cookies and Tracking Technologies\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text:
                    '- GameWatch does not use cookies or any other tracking technologies.\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '7. Changes to the Privacy Policy\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text:
                    '- Any changes to this privacy policy will be communicated to users through in-app messaging. We encourage you to review the policy periodically for any updates.\n\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: '8. Contact Information\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextSpan(
                text:
                    '- If you have any questions or concerns about this privacy policy, please contact us at: ashhas.studio@gmail.com\n',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text:
                    '- If you have any questions or concerns about this privacy policy, please contact us at: ashhas.studio@gmail.com\n',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

part of '../menu_container.dart';

class AppDetails extends StatelessWidget {
  const AppDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final appVersion = GetIt.instance.get<PackageInfo>().version;

    return Column(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: context.spacings.l),
            child: const Icon(
              Icons.emoji_symbols,
              size: 100.0,
            ),
          ),
        ),
        const Text(
          'Version',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Text(
          'v$appVersion',
          style: const TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      ],
    );
  }
}

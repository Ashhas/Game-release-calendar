part of '../more_container.dart';

class AppDetails extends StatelessWidget {
  const AppDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final appInfo = GetIt.instance.get<PackageInfo>();

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
        Text(
          '${appInfo.appName}',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Text(
          'v${appInfo.version}',
          style: const TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      ],
    );
  }
}

part of '../more_container.dart';

class AppTheme extends StatefulWidget {
  const AppTheme({super.key});

  @override
  State<AppTheme> createState() => _AppThemeState();
}

class _AppThemeState extends State<AppTheme> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Theme',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SwitchListTile(
            value: false,
            title: const Text('Dark Mode'),
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}

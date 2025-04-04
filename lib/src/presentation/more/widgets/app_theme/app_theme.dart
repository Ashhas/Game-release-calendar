part of '../../more_container.dart';

class AppTheme extends StatefulWidget {
  const AppTheme({super.key});

  @override
  State<AppTheme> createState() => _AppThemeState();
}

class _AppThemeState extends State<AppTheme> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();

    isDarkMode = context.read<ThemeCubit>().isDarkMode;
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
            value: isDarkMode,
            title: const Text('Dark Mode'),
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
                context.read<ThemeCubit>().setThemeMode(
                      isDarkMode ? AppThemeMode.dark : AppThemeMode.light,
                    );
              });
            },
          ),
        ],
      ),
    );
  }
}

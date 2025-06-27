part of '../../more_container.dart';

class AppTheme extends StatefulWidget {
  const AppTheme({super.key});

  @override
  State<AppTheme> createState() => _AppThemeState();
}

class _AppThemeState extends State<AppTheme> {
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
      body: BlocBuilder<ThemeCubit, AppThemePreset>(
        builder: (context, currentPreset) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                title: const Text('Light'),
                trailing: Radio<AppThemePreset>(
                  value: AppThemePreset.light,
                  groupValue: currentPreset,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeCubit>().setThemePreset(value);
                    }
                  },
                ),
                onTap: () {
                  context
                      .read<ThemeCubit>()
                      .setThemePreset(AppThemePreset.light);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                trailing: Radio<AppThemePreset>(
                  value: AppThemePreset.dark,
                  groupValue: currentPreset,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeCubit>().setThemePreset(value);
                    }
                  },
                ),
                onTap: () {
                  context
                      .read<ThemeCubit>()
                      .setThemePreset(AppThemePreset.dark);
                },
              ),
              ListTile(
                title: const Text('System'),
                subtitle: const Text('Follow system appearance'),
                trailing: Radio<AppThemePreset>(
                  value: AppThemePreset.system,
                  groupValue: currentPreset,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeCubit>().setThemePreset(value);
                    }
                  },
                ),
                onTap: () {
                  context
                      .read<ThemeCubit>()
                      .setThemePreset(AppThemePreset.system);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

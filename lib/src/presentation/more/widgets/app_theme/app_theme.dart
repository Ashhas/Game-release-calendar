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
        title: Text(
          'Theme',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return ListView(
            padding: EdgeInsets.all(context.spacings.m),
            children: [
              // Color Scheme Section
              Text(
                'Color Scheme',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: context.spacings.xs),
              Text(
                'Choose your preferred color palette',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              SizedBox(height: context.spacings.m),

              // Color Grid - Updated to include Red and improved layout
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  ColorSchemeCard(
                    preset: AppThemePreset.blueGrey,
                    title: 'Blue Grey',
                    color: const Color(0xFF819FC3),
                    isSelected: themeState.colorPreset == AppThemePreset.blueGrey,
                  ),
                  ColorSchemeCard(
                    preset: AppThemePreset.indigo,
                    title: 'Indigo',
                    color: Colors.indigo,
                    isSelected: themeState.colorPreset == AppThemePreset.indigo,
                  ),
                  ColorSchemeCard(
                    preset: AppThemePreset.teal,
                    title: 'Teal',
                    color: Colors.teal,
                    isSelected: themeState.colorPreset == AppThemePreset.teal,
                  ),
                  ColorSchemeCard(
                    preset: AppThemePreset.amber,
                    title: 'Amber',
                    color: Colors.amber,
                    isSelected: themeState.colorPreset == AppThemePreset.amber,
                  ),
                  ColorSchemeCard(
                    preset: AppThemePreset.red,
                    title: 'Red',
                    color: Colors.red,
                    isSelected: themeState.colorPreset == AppThemePreset.red,
                  ),
                ],
              ),

              SizedBox(height: context.spacings.xxl),

              // Brightness Section
              Text(
                'Appearance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: context.spacings.xs),
              Text(
                'Choose between light, dark, or system preference',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              SizedBox(height: context.spacings.m),

              // Brightness Options
              BrightnessOption(
                preset: AppThemePreset.light,
                title: 'Light',
                icon: Icons.light_mode,
                currentBrightnessMode: themeState.brightnessMode,
              ),
              BrightnessOption(
                preset: AppThemePreset.dark,
                title: 'Dark',
                icon: Icons.dark_mode,
                currentBrightnessMode: themeState.brightnessMode,
              ),
              BrightnessOption(
                preset: AppThemePreset.system,
                title: 'System',
                subtitle: 'Follow system appearance',
                icon: Icons.brightness_auto,
                currentBrightnessMode: themeState.brightnessMode,
              ),
            ],
          );
        },
      ),
    );
  }
}
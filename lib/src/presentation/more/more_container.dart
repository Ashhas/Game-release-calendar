import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:game_release_calendar/src/theme/app_theme_preset.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/url_helper.dart';
import '../../theme/state/theme_cubit.dart';
import '../../utils/constants.dart';
import '../../data/services/shared_prefs_service.dart';
import 'widgets/app_theme/widgets/color_scheme_card.dart';
import 'widgets/app_theme/widgets/brightness_option.dart';

part 'widgets/app_details.dart';

part 'widgets/privacy_policy.dart';

part 'widgets/options_list.dart';

part 'widgets/notifications/notifications.dart';

part 'widgets/app_theme/app_theme.dart';

part 'widgets/experimental_features/experimental_features.dart';

class MoreContainer extends StatefulWidget {
  const MoreContainer({super.key});

  @override
  State<MoreContainer> createState() => _MoreContainerState();
}

class _MoreContainerState extends State<MoreContainer> {
  bool _showExperimentalIcon = false;

  @override
  void initState() {
    super.initState();
    _loadExperimentalFeaturesVisibility();
  }

  void _loadExperimentalFeaturesVisibility() {
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();
    setState(() {
      _showExperimentalIcon = sharedPrefs.getExperimentalFeaturesEnabled();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          if (_showExperimentalIcon)
            IconButton(
              icon: const Icon(Icons.science_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ExperimentalFeatures(),
                  ),
                );
              },
            ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppDetails(
              onExperimentalUnlocked: _loadExperimentalFeaturesVisibility),
          SizedBox(height: context.spacings.l),
          const OptionsList(),
          const Spacer(),
          SizedBox(height: context.spacings.l),
        ],
      ),
    );
  }
}

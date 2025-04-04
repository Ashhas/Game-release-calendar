import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:game_release_calendar/src/theme/app_theme_mode.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/url_helper.dart';
import '../../theme/state/theme_cubit.dart';
import '../../utils/constants.dart';

part 'widgets/app_details.dart';

part 'widgets/privacy_policy.dart';

part 'widgets/options_list.dart';

part 'widgets/notifications/notifications.dart';

part 'widgets/app_theme/app_theme.dart';

class MoreContainer extends StatelessWidget {
  const MoreContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AppDetails(),
          SizedBox(height: context.spacings.l),
          const OptionsList(),
          const Spacer(),
          SizedBox(height: context.spacings.l),
        ],
      ),
    );
  }
}

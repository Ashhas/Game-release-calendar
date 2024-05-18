import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:game_release_calendar/src/theme/theme_extensions.dart';

part 'widgets/app_details.dart';

part 'widgets/privacy_policy.dart';

part 'widgets/options_list.dart';

part 'widgets/icon_row.dart';

class MenuContainer extends StatelessWidget {
  const MenuContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AppDetails(),
          SizedBox(height: context.spacings.l),
          const OptionsList(),
          const Spacer(),
          const IconRow(),
          SizedBox(height: context.spacings.l),
        ],
      ),
    );
  }
}

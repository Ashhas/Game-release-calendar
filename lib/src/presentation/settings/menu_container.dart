import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/presentation/settings/widgets/app_details.dart';
import 'package:game_release_calendar/src/presentation/settings/widgets/icon_row.dart';
import 'package:game_release_calendar/src/presentation/settings/widgets/options_list.dart';
import 'package:game_release_calendar/src/theme/context_extensions.dart';

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

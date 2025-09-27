import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/app_bar_header/widgets/filter_button.dart';

import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/game_update_status_indicator.dart';
import 'widgets/game_search_bar.dart';

class AppBarHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Upcoming Games'),
      actions: [
        const GameUpdateStatusIndicator(),
        const FilterButton(),
        Padding(
          padding: EdgeInsets.only(
            right: context.spacings.m,
          ),
        )
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(context.spacings.xxxl),
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacings.m,
              vertical: context.spacings.xxs,
            ),
            child: GameSearchBar(),
          ),
        ),
    );
  }
}

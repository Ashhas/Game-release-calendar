import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/app_bar_header/widgets/filter_button.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'widgets/game_search_bar.dart';

class AppBarHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Text('Upcoming Games'),
      actions: [
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

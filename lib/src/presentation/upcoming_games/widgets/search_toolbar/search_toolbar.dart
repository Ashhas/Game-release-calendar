import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:game_release_calendar/src/domain/enums/filter/date_filter_choice.dart';
import 'package:game_release_calendar/src/domain/enums/filter/platform_filter.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/date_range_utility.dart';
import 'package:moon_design/moon_design.dart';

part 'popups/date_filter_bottom_sheet.dart';

part 'popups/platform_filter_bottom_sheet.dart';

class SearchToolbar extends StatelessWidget {
  const SearchToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDateFilterSelected = context.select(
      (UpcomingGamesCubit cubit) =>
          cubit.state.selectedFilters.releaseDateChoice != null,
    );
    final isPlatformFilterSelected = context.select(
      (UpcomingGamesCubit cubit) {
        final platformChoices = cubit.state.selectedFilters.platformChoices;
        return platformChoices.isNotEmpty;
      },
    );

    void _showBottomSheet(Widget widget) => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => widget,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacings.xs,
          ).copyWith(
            bottom: context.spacings.xs,
          ),
          child: Row(
            children: [
              Expanded(
                  child: MoonTextInput(
                leading: Icon(LucideIcons.search),
                hintText: 'Search for games',
              )),
              const SizedBox(width: 8),
              MoonButton.icon(
                buttonSize: MoonButtonSize.sm,
                onTap: () {},
                icon: const Icon(LucideIcons.filter),
                backgroundColor: Colors.white,
                showBorder: true,
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 1),
      ],
    );
  }
}

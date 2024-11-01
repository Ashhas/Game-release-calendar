import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/domain/enums/filter/date_filter_choice.dart';
import 'package:game_release_calendar/src/domain/enums/filter/platform_filter.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/date_range_utility.dart';

part 'popups/date_filter_bottom_sheet.dart';

part 'popups/platform_filter_bottom_sheet.dart';

class FilterToolbar extends StatelessWidget {
  const FilterToolbar({super.key});

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
              FilterChip(
                label: Center(
                  child: const Text('Date'),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                selected: isDateFilterSelected,
                onSelected: (_) => _showBottomSheet(
                  BlocProvider.value(
                    value: BlocProvider.of<UpcomingGamesCubit>(context),
                    child: DateFilterBottomSheet(),
                  ),
                ),
              ),
              SizedBox(width: context.spacings.xs),
              FilterChip(
                label: Center(
                  child: const Text('Platform'),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                selected: isPlatformFilterSelected,
                onSelected: (_) => _showBottomSheet(
                  BlocProvider.value(
                    value: BlocProvider.of<UpcomingGamesCubit>(context),
                    child: PlatformFilterBottomSheet(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 1),
      ],
    );
  }
}

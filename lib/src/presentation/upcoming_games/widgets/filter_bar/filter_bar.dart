import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/domain/enums/date_filter_choice.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/date_helper.dart';

part 'popups/date_filter_bottom_sheet.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isSelected = context.select(
      (UpcomingGamesCubit cubit) =>
          cubit.state.selectedFilters.releaseDateChoice != null,
    );

    void _showBottomSheet() => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<UpcomingGamesCubit>(context),
            child: DateFilterBottomSheet(),
          ),
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
                selected: isSelected,
                onSelected: (_) => _showBottomSheet(),
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 1),
      ],
    );
  }
}

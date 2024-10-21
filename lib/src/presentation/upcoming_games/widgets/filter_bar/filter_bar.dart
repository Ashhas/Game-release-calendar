import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/filter_bar/popups/date_filter_bottom_sheet.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  @override
  Widget build(BuildContext context) {
    final isSelected = context.select(
      (UpcomingGamesCubit cubit) =>
          cubit.state.selectedFilters.releaseDateChoice != null,
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
          // ignore: avoid_single_child_in_flex
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
                onSelected: (_) {
                  _showBottomSheet();

                  print(
                    "Selected: " +
                        context
                            .read<UpcomingGamesCubit>()
                            .state
                            .selectedFilters
                            .releaseDateChoice
                            .toString(),
                  );
                },
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 1),
      ],
    );
  }

  void _showBottomSheet() =>
      // ignore: prefer_async_await
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<UpcomingGamesCubit>(context),
          child: DateFilterBottomSheet(),
        ),
      );
}

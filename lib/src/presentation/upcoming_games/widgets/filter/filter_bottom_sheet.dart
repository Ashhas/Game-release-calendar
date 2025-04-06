import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

import '../../../../domain/enums/filter/date_filter_choice.dart';
import '../../../../domain/enums/filter/platform_filter.dart';
import '../../state/upcoming_games_cubit.dart';

part 'widgets/platform_filters.dart';

part 'widgets/date_filters.dart';

part 'widgets/footer.dart';

part 'widgets/top_bar.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<PlatformFilter> _selectedPlatformFilterOptions;
  late DateFilterChoice? _selectedDateFilterOption;

  @override
  void initState() {
    super.initState();
    _selectedPlatformFilterOptions = Set.of(
      context.read<UpcomingGamesCubit>().state.selectedFilters.platformChoices,
    );
    _selectedDateFilterOption = context
        .read<UpcomingGamesCubit>()
        .state
        .selectedFilters
        .releaseDateChoice;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacings.m),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          _TopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: context.spacings.m),
                  _DateFilters(
                    selectedDateFilterOption: _selectedDateFilterOption,
                    onDateFilterChanged: (value) {
                      setState(() {
                        _selectedDateFilterOption = value;
                      });
                    },
                  ),
                  SizedBox(height: context.spacings.m),
                  _PlatformFilters(
                    selectedPlatformFilterOptions:
                        _selectedPlatformFilterOptions,
                  ),
                ],
              ),
            ),
          ),
          Footer(
            onApplyFilter: () => _applyFilters(context),
            onResetFilter: () => _resetFilters(context),
          ),
        ],
      ),
    );
  }

  Future<void> _applyFilters(BuildContext context) async {
    await context.read<UpcomingGamesCubit>().applySearchFilters(
          platformChoices: _selectedPlatformFilterOptions,
          setDateChoice: _selectedDateFilterOption,
        );
    context.read<UpcomingGamesCubit>().getGames();
    Navigator.pop(context);
  }

  Future<void> _resetFilters(BuildContext context) async {
    setState(() {
      _selectedPlatformFilterOptions = {};
      _selectedDateFilterOption = DateFilterChoice.allTime;
    });
  }
}

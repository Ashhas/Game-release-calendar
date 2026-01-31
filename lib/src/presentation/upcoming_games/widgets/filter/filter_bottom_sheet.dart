import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/domain/enums/game_category.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import '../../../../domain/enums/filter/date_filter_choice.dart';
import '../../../../domain/enums/filter/platform_filter.dart';
import '../../../../domain/enums/filter/release_precision_filter.dart';
import '../../state/upcoming_games_cubit.dart';

part 'widgets/platform_filters.dart';

part 'widgets/date_filters.dart';

part 'widgets/category_filters.dart';


part 'widgets/footer.dart';

part 'widgets/top_bar.dart';

part 'widgets/collapsible_filter_section.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<PlatformFilter> _selectedPlatformFilterOptions;
  late DateFilterChoice? _selectedDateFilterOption;
  late Set<int> _selectedCategoryFilterOptions;
  late ReleasePrecisionFilter? _selectedPrecisionFilterOption;

  @override
  void initState() {
    super.initState();
    _selectedPlatformFilterOptions = Set.of(
      context.read<UpcomingGamesCubit>().state.selectedFilters.platformChoices,
    );
    _selectedCategoryFilterOptions = Set.of(
      context.read<UpcomingGamesCubit>().state.selectedFilters.categoryIds,
    );
    _selectedDateFilterOption = context
        .read<UpcomingGamesCubit>()
        .state
        .selectedFilters
        .releaseDateChoice;
    _selectedPrecisionFilterOption = context
        .read<UpcomingGamesCubit>()
        .state
        .selectedFilters
        .releasePrecisionChoice;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacings.m),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.spacings.m)),
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
                  _PrecisionFilters(
                    selectedPrecisionFilterOption: _selectedPrecisionFilterOption,
                    onPrecisionFilterChanged: (value) {
                      setState(() {
                        _selectedPrecisionFilterOption = value;
                      });
                    },
                  ),
                  SizedBox(height: context.spacings.m),
                  _PlatformFilters(
                    selectedPlatformFilterOptions:
                        _selectedPlatformFilterOptions,
                  ),
                  _CategoryFilters(
                    selectedCategoryFilterOptions:
                        _selectedCategoryFilterOptions,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: context.spacings.m),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewPaddingOf(context).bottom,
            ),
            child: Footer(
              onApplyFilter: () => _applyFilters(context),
              onResetFilter: () => _resetFilters(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _applyFilters(BuildContext context) async {
    await context.read<UpcomingGamesCubit>().applySearchFilters(
          platformChoices: _selectedPlatformFilterOptions,
          setDateChoice: _selectedDateFilterOption,
          categoryId: _selectedCategoryFilterOptions,
          precisionChoice: _selectedPrecisionFilterOption,
        );
    context.read<UpcomingGamesCubit>().getGames();
    Navigator.pop(context);
  }

  Future<void> _resetFilters() async {
    setState(() {
      _selectedPlatformFilterOptions = {};
      _selectedCategoryFilterOptions = {};
      _selectedDateFilterOption = DateFilterChoice.allTime;
      _selectedPrecisionFilterOption = ReleasePrecisionFilter.all;
    });
  }
}

class _PrecisionFilters extends StatefulWidget {
  const _PrecisionFilters({
    required this.selectedPrecisionFilterOption,
    required this.onPrecisionFilterChanged,
  });

  final ReleasePrecisionFilter? selectedPrecisionFilterOption;
  final Function(ReleasePrecisionFilter? choice)? onPrecisionFilterChanged;

  @override
  State<_PrecisionFilters> createState() => _PrecisionFiltersState();
}

class _PrecisionFiltersState extends State<_PrecisionFilters> {
  bool _isExpanded = false;

  // Simplified options: show all games (including TBD sections) or exact dates only
  final _options = <ReleasePrecisionFilter, String>{
    ReleasePrecisionFilter.all: 'All (incl. TBD periods)',
    ReleasePrecisionFilter.exactDate: 'Exact Dates Only',
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: context.spacings.xs),
            child: Row(
              children: [
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 24,
                ),
                SizedBox(width: context.spacings.xs),
                const Text(
                  'Release Date Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (widget.selectedPrecisionFilterOption != null &&
                    widget.selectedPrecisionFilterOption != ReleasePrecisionFilter.all &&
                    !_isExpanded)
                  Chip(
                    label: Text(
                      _options[widget.selectedPrecisionFilterOption] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    backgroundColor: colorScheme.primary,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.symmetric(horizontal: context.spacings.xs),
                  ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: EdgeInsets.only(left: context.spacings.xxl),
            child: Wrap(
              spacing: context.spacings.xxs,
              runSpacing: context.spacings.xxs,
              children: _options.entries.map((entry) {
                final isSelected = widget.selectedPrecisionFilterOption == entry.key;
                return ChoiceChip(
                  label: Text(
                    entry.value,
                    style: TextStyle(
                      color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: colorScheme.primary,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  onSelected: (selected) {
                    widget.onPrecisionFilterChanged?.call(selected ? entry.key : null);
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

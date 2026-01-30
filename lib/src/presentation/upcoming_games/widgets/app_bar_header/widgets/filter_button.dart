import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/styled_icon_button.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/domain/enums/filter/date_filter_choice.dart';
import 'package:game_release_calendar/src/domain/enums/filter/release_precision_filter.dart';
import '../../filter/filter_bottom_sheet.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  static int _calculateActiveFilterCount(UpcomingGamesState state) {
    try {
      final filters = state.selectedFilters;
      final platformCount = filters.platformChoices.length;
      final categoryCount = filters.categoryIds.length;
      final dateCount = _shouldCountDateFilter(filters.releaseDateChoice) ? 1 : 0;
      final precisionCount = _shouldCountPrecisionFilter(filters.releasePrecisionChoice) ? 1 : 0;
      return platformCount + categoryCount + dateCount + precisionCount;
    } catch (e) {
      debugPrint('Error calculating filter count: $e');
      return 0;
    }
  }

  static bool _shouldCountDateFilter(DateFilterChoice? dateChoice) {
    return dateChoice != null && dateChoice != DateFilterChoice.allTime;
  }

  static bool _shouldCountPrecisionFilter(ReleasePrecisionFilter? precisionChoice) {
    // Count as active filter if set to something other than "all"
    return precisionChoice != null && precisionChoice != ReleasePrecisionFilter.all;
  }


  void _openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.spacings.xl),
        ),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<UpcomingGamesCubit>(context),
          child: const FilterBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingGamesCubit, UpcomingGamesState>(
      builder: (context, state) {
        final activeFilterCount = _calculateActiveFilterCount(state);
        final hasActiveFilters = activeFilterCount > 0;
        final colorScheme = Theme.of(context).colorScheme;

        return Semantics(
          label: 'Open game filters',
          hint: 'Filter games by platform, category, and release dates',
          button: true,
          child: Stack(
            children: [
              StyledIconButton.icon(
                buttonSize: StyledButtonSize.medium,
                backgroundColor: hasActiveFilters
                    ? colorScheme.primaryContainer
                    : colorScheme.surface,
                showBorder: false,
                tooltip: 'Open game filters',
                onTap: () => _openFilterBottomSheet(context),
                icon: LucideIcons.list_filter,
                iconColor: hasActiveFilters ? colorScheme.primary : null,
              ),
              if (hasActiveFilters)
                _FilterBadge(count: activeFilterCount),
            ],
          ),
        );
      },
    );
  }
}

class _FilterBadge extends StatelessWidget {
  const _FilterBadge({required this.count});

  final int count;

  static const double _badgeSize = 18.0;
  static const double _badgeTopOffset = 2.0;
  static const double _badgeRightOffset = 2.0;
  static const double _badgeFontSize = 10.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      top: _badgeTopOffset,
      right: _badgeRightOffset,
      child: Container(
        padding: EdgeInsets.all(context.spacings.xxs),
        decoration: BoxDecoration(
          color: colorScheme.error,
          shape: BoxShape.circle,
        ),
        constraints: const BoxConstraints(
          minWidth: _badgeSize,
          minHeight: _badgeSize,
        ),
        child: Text(
          '$count',
          style: TextStyle(
            color: colorScheme.onError,
            fontSize: _badgeFontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

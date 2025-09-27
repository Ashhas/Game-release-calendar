import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/styled_icon_button.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import '../../filter/filter_bottom_sheet.dart';

/// A button widget that opens the filter bottom sheet
class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Open game filters',
      hint: 'Filter games by platform, category, and release dates',
      button: true,
      child: StyledIconButton.icon(
        buttonSize: StyledButtonSize.medium,
        backgroundColor: Theme.of(context).colorScheme.surface,
        showBorder: false,
        tooltip: 'Open game filters',
        onTap: () {
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
        },
        icon: LucideIcons.list_filter,
      ),
    );
  }
}

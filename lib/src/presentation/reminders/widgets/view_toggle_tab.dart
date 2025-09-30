import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';

class ViewToggleTab extends StatelessWidget {
  const ViewToggleTab({
    super.key,
    required this.selectedIndex,
  });

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return FlutterToggleTab(
      width: 35,
      borderRadius: 12,
      dataTabs: [
        DataTab(
          icon: Icons.grid_view,
        ),
        DataTab(
          icon: Icons.grid_on,
        ),
        DataTab(
          icon: Icons.list,
        ),
      ],
      selectedBackgroundColors: [
        Theme.of(context).colorScheme.tertiary,
      ],
      unSelectedBackgroundColors: const [
        Color(0x805E5E5E),
      ],
      selectedTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      unSelectedTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      selectedIndex: selectedIndex,
      selectedLabelIndex: (index) {
        context.read<RemindersCubit>().storePreferredDataView(index);
      },
    );
  }
}
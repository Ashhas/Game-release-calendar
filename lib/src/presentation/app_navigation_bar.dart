import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:game_release_calendar/src/presentation/more/more_container.dart';
import 'package:game_release_calendar/src/presentation/reminders/reminders_container.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/upcoming_games_container.dart';

class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({super.key});

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int _currentPageIndex = 0;
  Key _rebuildScreenKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UpcomingGamesCubit>().getGames();
      context.read<NotificationsCubit>().retrievePendingNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;

            // If selecting the "Reminders" screen, generate a new key to force rebuild
            if (index == 1) {
              _rebuildScreenKey = UniqueKey();
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.gamepad_2),
            label: 'Upcoming',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.bell),
            activeIcon: Icon(LucideIcons.bell_ring),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.ellipsis),
            label: 'More',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          const UpcomingGamesContainer(),
          RemindersContainer(key: _rebuildScreenKey),
          const MoreContainer(),
        ],
      ),
    );
  }
}

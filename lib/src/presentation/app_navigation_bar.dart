import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get_it/get_it.dart';

import 'package:game_release_calendar/src/data/services/analytics_service.dart';
import 'package:game_release_calendar/src/presentation/common/state/game_update_cubit/game_update_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/game_updates_badge_cubit/game_updates_badge_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/presentation/more/more_container.dart';
import 'package:game_release_calendar/src/presentation/reminders/reminders_container.dart';
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

  final _analyticsService = GetIt.instance.get<AnalyticsService>();

  /// Screen names for analytics tracking, indexed to match tab positions.
  /// Index 0 = Upcoming, Index 1 = Reminders, Index 2 = More
  static const _screenNames = ['Upcoming', 'Reminders', 'More'];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UpcomingGamesCubit>().getGames();
      context.read<NotificationsCubit>().retrievePendingNotifications();
      // Start background game update check
      context.read<GameUpdateCubit>().startBackgroundUpdate();
      // Initialize badge status
      context.read<GameUpdatesBadgeCubit>().checkBadgeStatus();

      // Track initial screen view
      _analyticsService.trackScreenViewed(screenName: _screenNames.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          // Clear focus when navigating away from the search screen (Upcoming tab)
          if (_currentPageIndex == 0 && index != 0) {
            FocusScope.of(context).unfocus();
          }

          // Track screen view when switching tabs
          if (_currentPageIndex != index) {
            _analyticsService.trackScreenViewed(
              screenName: _screenNames[index],
            );
          }

          setState(() {
            _currentPageIndex = index;

            // If selecting the "Reminders" screen, generate a new key to force rebuild
            if (index == 1) {
              _rebuildScreenKey = UniqueKey();
              // Refresh badge status when navigating to Reminders tab
              context.read<GameUpdatesBadgeCubit>().checkBadgeStatus();
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

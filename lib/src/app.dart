import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:toastification/toastification.dart';

import 'package:game_release_calendar/src/data/services/analytics_service.dart';
import 'package:game_release_calendar/src/data/services/game_update_service.dart';
import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/domain/models/game_update_log.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/presentation/app_navigation_bar.dart';
import 'package:game_release_calendar/src/presentation/common/state/game_update_cubit/game_update_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/game_updates_badge_cubit/game_updates_badge_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/toast/global_state_listener.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/analytics_consent_dialog.dart';
import 'package:game_release_calendar/src/presentation/game_detail/state/game_detail_cubit.dart';
import 'package:game_release_calendar/src/presentation/game_updates/state/game_updates_cubit.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/theme/custom_theme.dart';
import 'package:game_release_calendar/src/theme/state/theme_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(_) {
    return ToastificationWrapper(
      child: MultiBlocProvider(
        providers: [
        BlocProvider<NotificationsCubit>.value(
          value: GetIt.instance.get<NotificationsCubit>(),
        ),
        BlocProvider<UpcomingGamesCubit>(
          create: (_) => UpcomingGamesCubit(
            igdbService: GetIt.instance.get<IGDBService>(),
            analyticsService: GetIt.instance.get<AnalyticsService>(),
          ),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(
            GetIt.instance.get<SharedPrefsService>(),
            analyticsService: GetIt.instance.get<AnalyticsService>(),
          ),
        ),
        BlocProvider<GameDetailCubit>(
          create: (_) => GameDetailCubit(
            remindersBox: GetIt.instance.get<Box<GameReminder>>(),
            notificationsCubit: GetIt.instance.get<NotificationsCubit>(),
            analyticsService: GetIt.instance.get<AnalyticsService>(),
          ),
        ),
        BlocProvider<RemindersCubit>(
          create: (_) => RemindersCubit(
            remindersBox: GetIt.instance.get<Box<GameReminder>>(),
            notificationsCubit: GetIt.instance.get<NotificationsCubit>(),
            prefsService: GetIt.instance.get<SharedPrefsService>(),
          ),
        ),
        BlocProvider<GameUpdateCubit>(
          create: (_) => GameUpdateCubit(
            gameUpdateService: GetIt.instance.get<GameUpdateService>(),
          ),
        ),
        BlocProvider<GameUpdatesCubit>(
          create: (_) => GameUpdatesCubit(
            gameUpdateLogBox: GetIt.instance.get<Box<GameUpdateLog>>(),
          ),
        ),
        BlocProvider<GameUpdatesBadgeCubit>(
          create: (_) => GameUpdatesBadgeCubit(
            remindersBox: GetIt.instance.get<Box<GameReminder>>(),
            gameUpdateLogBox: GetIt.instance.get<Box<GameUpdateLog>>(),
            prefsService: GetIt.instance.get<SharedPrefsService>(),
          ),
        ),
      ],
      child: Builder(
        builder: (_) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            buildWhen: (previous, current) =>
                previous.seedColor != current.seedColor ||
                previous.themeMode != current.themeMode,
            builder: (__, themeState) {
              return MaterialApp(
                title: GetIt.instance.get<PackageInfo>().appName,
                theme: CustomTheme.lightTheme(seedColor: themeState.seedColor),
                darkTheme: CustomTheme.darkTheme(seedColor: themeState.seedColor),
                themeMode: themeState.themeMode,
                themeAnimationDuration: const Duration(milliseconds: 200),
                themeAnimationCurve: Curves.easeInOut,
                home: const _ConsentGate(
                  child: GlobalStateListener(
                    child: AppNavigationBar(),
                  ),
                ),
              );
            },
          );
        },
      ),
      ),
    );
  }
}

/// Shows analytics consent dialog on first launch before showing the main app.
class _ConsentGate extends StatefulWidget {
  const _ConsentGate({required this.child});

  final Widget child;

  @override
  State<_ConsentGate> createState() => _ConsentGateState();
}

class _ConsentGateState extends State<_ConsentGate> {
  @override
  void initState() {
    super.initState();
    // Show consent dialog after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConsent();
    });
  }

  Future<void> _checkConsent() async {
    await AnalyticsConsentDialog.showIfNeeded(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/theme/state/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:game_release_calendar/src/presentation/app_navigation_bar.dart';
import 'package:game_release_calendar/src/presentation/game_detail/state/game_detail_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/theme/custom_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(_) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationsCubit>(
          create: (_) => NotificationsCubit(
            notificationClient: GetIt.instance.get<NotificationClient>(),
          ),
        ),
        BlocProvider<UpcomingGamesCubit>(
          create: (_) => UpcomingGamesCubit(
            igdbService: GetIt.instance.get<IGDBService>(),
          ),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(
            GetIt.instance.get<SharedPrefsService>(),
          ),
        ),
        BlocProvider<RemindersCubit>(
          create: (_) => RemindersCubit(
            remindersBox: GetIt.instance.get<Box<GameReminder>>(),
          ),
        ),
        BlocProvider<GameDetailCubit>(
          create: (context) => GameDetailCubit(
            remindersBox: GetIt.instance.get<Box<GameReminder>>(),
            notificationsCubit: context.read<NotificationsCubit>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (_, themeMode) {
              return MaterialApp(
                title: GetIt.instance.get<PackageInfo>().appName,
                theme: CustomTheme.lightTheme,
                darkTheme: CustomTheme.darkTheme,
                themeMode: themeMode,
                home: AppNavigationBar(),
              );
            },
          );
        },
      ),
    );
  }
}

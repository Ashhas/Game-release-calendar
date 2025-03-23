import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/app_navigation_bar.dart';
import 'package:game_release_calendar/src/presentation/game_detail/state/game_detail_cubit.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/theme/custom_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UpcomingGamesCubit>(
          create: (_) => UpcomingGamesCubit(
            igdbService: GetIt.instance.get<IGDBService>(),
          ),
        ),
        BlocProvider<RemindersCubit>(
          lazy: false,
          create: (_) => RemindersCubit(
            notificationClient: GetIt.instance.get<NotificationClient>(),
          ),
        ),
        BlocProvider<GameDetailCubit>(
          create: (_) => GameDetailCubit(
            remindersBox: GetIt.instance.get<Box<Game>>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: GetIt.instance.get<PackageInfo>().appName,
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: AppNavigationBar(),
      ),
    );
  }
}

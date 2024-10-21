import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/presentation/app_navigation_bar.dart';
import 'package:get_it/get_it.dart';

import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/theme/custom_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Release Calendar',
      theme: CustomTheme.lightTheme(),
      darkTheme: CustomTheme.darkTheme(),
      themeMode: ThemeMode.dark,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<UpcomingGamesCubit>(
            lazy: false,
            create: (_) => UpcomingGamesCubit(
              igdbService: GetIt.instance.get<IGDBService>(),
            ),
          ),
        ],
        child: AppNavigationBar(),
      ),
    );
  }
}

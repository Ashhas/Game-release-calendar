import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/utils/convert_functions.dart';
import 'package:intl/intl.dart';

part 'widgets/game_tile.dart';

class RemindersContainer extends StatefulWidget {
  const RemindersContainer({super.key});

  @override
  State<RemindersContainer> createState() => _RemindersContainerState();
}

class _RemindersContainerState extends State<RemindersContainer> {
  late final List<Game> savedGames;

  @override
  void initState() {
    super.initState();

    savedGames = context.read<RemindersCubit>().getGames();
  }

  DateTime _fromEpochToDateTime(int? timestamp) {
    return timestamp != null
        ? ConvertFunctions.secondSinceEpochToDateTime(
            timestamp,
          )
        : DateTime.now();
  }

  String _convertDateTimeDay(DateTime dateTime) {
    return DateFormat('dd').format(dateTime);
  }

  String _convertDateTimeMonth(DateTime dateTime) {
    return DateFormat('MMMM').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView.builder(
        itemCount: savedGames.length,
        itemBuilder: (_, int index) {
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _convertDateTimeDay(
                          _fromEpochToDateTime(
                            savedGames[index].firstReleaseDate,
                          ),
                        ),
                      ),
                      Text(
                        _convertDateTimeMonth(
                          _fromEpochToDateTime(
                            savedGames[index].firstReleaseDate,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Text(
                    savedGames[index].name,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

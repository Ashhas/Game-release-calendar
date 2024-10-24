import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/utils/convert_functions.dart';

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
            title: Text(savedGames[index].name),
            subtitle: savedGames[index].platforms != null
                ? Wrap(
                    spacing: 4.0,
                    children: savedGames[index]
                        .platforms!
                        .map(
                          (platform) => Chip(
                            label: Text(
                              platform.abbreviation ?? platform.name ?? 'N/A',
                            ),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                        )
                        .toList(),
                  )
                : null,
          );
        },
      ),
    );
  }
}

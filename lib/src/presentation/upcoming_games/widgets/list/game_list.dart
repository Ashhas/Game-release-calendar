import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/date_time_converter.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';

part 'section/day_section.dart';

part 'section/section_header.dart';

part 'game_tile/game_tile.dart';

class GameList extends StatefulWidget {
  const GameList({
    required this.games,
    super.key,
  });

  final Map<DateTime, List<Game>> games;

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  late Map<DateTime, List<Game>> _activeList = {};
  late int _requestLimit;
  late int _offset;
  late bool _isLastPage;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _requestLimit = 500;
    _offset = _requestLimit;
    _isLastPage = false;
    _isLoading = false;
    _activeList = Map.of(widget.games);
  }

  int _getTotalItems() {
    return _activeList.values.fold(0, (sum, games) => sum + games.length);
  }

  void _updateGameList(List<Game> newGames) {
    final newGroupedGames = GameDateGrouper.groupGamesByReleaseDate(newGames);
    final updatedList = {..._activeList};

    newGroupedGames.forEach((date, games) {
      updatedList.update(
        date,
        (existingGames) => existingGames..addAll(games),
        ifAbsent: () => games,
      );
    });

    setState(() {
      _activeList = updatedList;
    });
  }

  void _fetchData() async {
    if (_isLastPage || _getTotalItems() < _requestLimit) {
      print('Last page reached or max items fetched!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final newGames =
          await context.read<UpcomingGamesCubit>().getGamesWithOffset(_offset);

      if (newGames.isNotEmpty) {
        _updateGameList(newGames);
        setState(() => _offset += _requestLimit);
      }

      if (newGames.length < _requestLimit) {
        setState(() => _isLastPage = true);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InfiniteList(
      itemCount: _activeList.length,
      isLoading: _isLoading,
      onFetchData: _fetchData,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        if (_activeList.isEmpty) {
          return const Center(child: Text('No games found'));
        }

        final entry = _activeList.entries.elementAt(index);

        return DaySection(
          groupedGames: entry,
          key: ValueKey(entry.key),
        );
      },
    );
  }
}

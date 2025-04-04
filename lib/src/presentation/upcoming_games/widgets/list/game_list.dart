import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/constants.dart';
import 'package:game_release_calendar/src/utils/date_range_utility.dart';
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
  final ScrollController _scrollController = ScrollController();

  late Map<DateTime, List<Game>> _activeList;
  int _requestLimit = Constants.gameRequestLimit;
  int _offset = Constants.gameRequestLimit;
  bool _isLastPage = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _activeList = Map.of(widget.games);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _extendUpcomingGamesList(List<Game> newGames) {
    final newGroupedGames = GameDateGrouper.groupGamesByReleaseDate(newGames);

    newGroupedGames.forEach((date, games) {
      _activeList.update(
        date,
        (existingGames) => existingGames..addAll(games),
        ifAbsent: () => games,
      );
    });

    setState(() {});
  }

  void _fetchData() async {
    if (_isLastPage || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final newGames =
          await context.read<UpcomingGamesCubit>().getGamesWithOffset(_offset);

      if (newGames.isNotEmpty) {
        _extendUpcomingGamesList(newGames);
        _offset += _requestLimit;
      }

      if (newGames.length < _requestLimit) {
        _isLastPage = true;
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300 && !_isLoading) {
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = _activeList.entries.toList();

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (entries.isEmpty)
          const SliverFillRemaining(
            child: Center(
              child: Text('No games found'),
            ),
          )
        else
          for (var entry in entries)
            DaySection(
              groupedGames: entry,
              key: ValueKey(entry.key),
            ),
        if (_isLoading)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

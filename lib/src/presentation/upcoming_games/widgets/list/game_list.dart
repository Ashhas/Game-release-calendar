import 'package:flutter/material.dart';

import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/date_scrollbar/date_scrollbar.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/constants.dart';
import 'package:game_release_calendar/src/utils/date_range_utility.dart';
import 'package:game_release_calendar/src/utils/date_time_converter.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';

part 'section/day_section.dart';
part 'section/section_header.dart';
part 'game_tile/game_tile.dart';
part 'widgets/_game_list_scroll_view.dart';
part 'physics/snap_scroll_physics.dart';

class GameList extends StatefulWidget {
  const GameList({
    required this.games,
    super.key,
  });

  final Map<DateTime, List<Game>> games;

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final Map<DateTime, GlobalKey> _sectionKeys = {};

  late Map<DateTime, List<Game>> _activeList;
  int _requestLimit = Constants.gameRequestLimit;
  int _offset = Constants.gameRequestLimit;
  bool _isLastPage = false;
  bool _isLoading = false;
  bool _isScrollbarEnabled = false;

  @override
  void initState() {
    super.initState();
    _activeList = Map.of(widget.games);
    _scrollController.addListener(_onScroll);
    _generateSectionKeys();
    _loadScrollbarSettings();
    WidgetsBinding.instance.addObserver(this);
    _checkSettingsUpdates();
  }

  void _loadScrollbarSettings() {
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();
    setState(() {
      _isScrollbarEnabled = sharedPrefs.getScrollbarEnabled();
    });
  }

  @override
  void didUpdateWidget(GameList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadScrollbarSettings();
  }

  void _generateSectionKeys() {
    _sectionKeys.clear();
    for (final date in _activeList.keys) {
      _sectionKeys[date] = GlobalKey();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _loadScrollbarSettings();
    }
  }

  void _checkSettingsUpdates() {
    if (mounted) {
      final sharedPrefs = GetIt.instance.get<SharedPrefsService>();
      final currentSetting = sharedPrefs.getScrollbarEnabled();
      if (currentSetting != _isScrollbarEnabled) {
        setState(() {
          _isScrollbarEnabled = currentSetting;
        });
      }

      Future.delayed(const Duration(seconds: 1), _checkSettingsUpdates);
    }
  }

  void _extendUpcomingGamesList(List<Game> newGames) {
    final newGroupedGames = GameDateGrouper.groupGamesByReleaseDate(newGames);

    newGroupedGames.forEach((date, games) {
      _activeList.update(
        date,
        (existingGames) => existingGames..addAll(games),
        ifAbsent: () {
          _sectionKeys[date] = GlobalKey();
          return games;
        },
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

  void _scrollToDate(DateTime date) {
    final key = _sectionKeys[date];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedEntries = _activeList.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final availableDates = _extractSortedDates(sortedEntries);

    return Stack(
      children: [
        _GameListScrollView(
          entries: sortedEntries,
          scrollController: _scrollController,
          sectionKeys: _sectionKeys,
          isLoading: _isLoading,
          isScrollbarEnabled: _isScrollbarEnabled,
        ),
        if (availableDates.isNotEmpty && _isScrollbarEnabled)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: DateScrollbar(
              dates: availableDates,
              scrollController: _scrollController,
              onDateTap: _scrollToDate,
            ),
          ),
      ],
    );
  }

  List<DateTime> _extractSortedDates(
      List<MapEntry<DateTime, List<Game>>> entries) {
    return entries.map((entry) => entry.key).toList()..sort();
  }
}

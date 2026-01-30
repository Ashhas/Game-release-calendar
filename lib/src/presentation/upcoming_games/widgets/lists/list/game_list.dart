import 'dart:async';

import 'package:flutter/material.dart';

import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/domain/enums/date_precision.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/game_section.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/date_scrollbar/date_scrollbar.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/constants.dart';
import 'package:game_release_calendar/src/utils/date_range_utility.dart';
import 'package:game_release_calendar/src/utils/date_utilities.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';

part 'widgets/section/day_section.dart';
part 'widgets/section/section_header.dart';
part 'widgets/game_tile/game_tile.dart';
part 'widgets/_game_list_scroll_view.dart';
part 'physics/snap_scroll_physics.dart';

class GameList extends StatefulWidget {
  const GameList({
    required this.sections,
    super.key,
  });

  final List<GameSection> sections;

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};

  late List<GameSection> _activeSections;
  int _requestLimit = Constants.gameRequestLimit;
  int _offset = Constants.gameRequestLimit;
  bool _isLastPage = false;
  bool _isLoading = false;
  bool _isScrollbarEnabled = false;
  Timer? _settingsTimer;

  @override
  void initState() {
    super.initState();
    _activeSections = List.of(widget.sections);
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
    for (final section in _activeSections) {
      _sectionKeys[section.key] = GlobalKey();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _settingsTimer?.cancel();
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

      _settingsTimer?.cancel();
      _settingsTimer = Timer(const Duration(seconds: 1), _checkSettingsUpdates);
    }
  }

  void _extendUpcomingGamesList(List<Game> newGames) {
    final newSections = GameDateGrouper.groupGamesIntoSections(newGames);

    for (final newSection in newSections) {
      final existingIndex = _activeSections.indexWhere(
        (s) => s.key == newSection.key,
      );

      if (existingIndex != -1) {
        // Add games to existing section
        _activeSections[existingIndex].games.addAll(newSection.games);
      } else {
        // Add new section and generate key
        _sectionKeys[newSection.key] = GlobalKey();
        _activeSections.add(newSection);
      }
    }

    // Re-sort sections after adding new ones
    _activeSections.sort((a, b) {
      final dateComparison = a.date.compareTo(b.date);
      if (dateComparison != 0) return dateComparison;
      return a.precision.sortOrder.compareTo(b.precision.sortOrder);
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

  void _scrollToSection(String sectionKey) {
    final key = _sectionKeys[sectionKey];
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
    // Extract unique dates for the scrollbar (exact dates only for simplicity)
    final availableDates = _activeSections
        .where((s) => s.precision == DatePrecision.exactDay)
        .map((s) => s.date)
        .toList();

    return Stack(
      children: [
        _GameListScrollView(
          sections: _activeSections,
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
              onDateTap: (date) {
                // Find the section key for this date
                final matchingSection = _activeSections.where(
                  (s) => s.date.isAtSameDayAs(date) && s.precision == DatePrecision.exactDay,
                );
                if (matchingSection.isNotEmpty) {
                  _scrollToSection(matchingSection.first.key);
                }
              },
            ),
          ),
      ],
    );
  }
}

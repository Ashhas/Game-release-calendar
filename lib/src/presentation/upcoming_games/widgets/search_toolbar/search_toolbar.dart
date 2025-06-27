import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:moon_design/moon_design.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import '../filter/filter_bottom_sheet.dart';

class SearchToolbar extends StatefulWidget {
  const SearchToolbar({super.key});

  @override
  State<SearchToolbar> createState() => _SearchToolbarState();
}

class _SearchToolbarState extends State<SearchToolbar> {
  final TextEditingController _searchController = TextEditingController();
  bool _showClearButton = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _showClearButton = false;
    });
    context.read<UpcomingGamesCubit>().updateNameQuery('');
    context.read<UpcomingGamesCubit>().searchGames('');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpcomingGamesCubit, UpcomingGamesState>(
      listener: (context, state) {
        if (state.nameQuery.isEmpty && _searchController.text.isNotEmpty) {
          _searchController.clear();
          setState(() {
            _showClearButton = false;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacings.xs,
            ).copyWith(
              bottom: context.spacings.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    label: 'Search for games',
                    hint: 'Enter game title to search',
                    child: MoonTextInput(
                      controller: _searchController,
                      autofocus: false,
                      leading: Icon(Icons.search),
                      trailing: _showClearButton
                          ? Semantics(
                              label: 'Clear search field',
                              button: true,
                              child: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: _clearSearch,
                                tooltip: 'Clear search',
                              ),
                            )
                          : null,
                      hintText: 'Search for games',
                      onChanged: (value) async {
                        setState(() {
                          _showClearButton = value.isNotEmpty;
                        });
                        await context
                            .read<UpcomingGamesCubit>()
                            .updateNameQuery(value);
                        context.read<UpcomingGamesCubit>().searchGames(value);
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Row(
                    children: [
                      SizedBox(width: context.spacings.xs),
                      Semantics(
                        label: 'Open game filters',
                        hint: 'Filter games by platform, category, and release dates',
                        button: true,
                        child: MoonButton.icon(
                          buttonSize: MoonButtonSize.sm,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          showBorder: true,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(context.spacings.xl),
                                ),
                              ),
                              builder: (context) {
                                return BlocProvider.value(
                                  value: BlocProvider.of<UpcomingGamesCubit>(
                                      context),
                                  child: FilterBottomSheet(),
                                );
                              },
                            );
                          },
                          icon: const Icon(LucideIcons.filter),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 1),
        ],
      ),
    );
  }
}

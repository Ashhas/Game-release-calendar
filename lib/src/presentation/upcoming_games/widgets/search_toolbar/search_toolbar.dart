import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:moon_design/moon_design.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
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
    return Column(
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
                child: MoonTextInput(
                  controller: _searchController,
                  autofocus: false,
                  leading: Icon(Icons.search),
                  trailing: _showClearButton
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: _clearSearch,
                          tooltip: 'Clear search',
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
              Visibility(
                visible: true,
                child: Row(
                  children: [
                    SizedBox(width: context.spacings.xs),
                    MoonButton.icon(
                      buttonSize: MoonButtonSize.sm,
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
                              value:
                                  BlocProvider.of<UpcomingGamesCubit>(context),
                              child: FilterBottomSheet(),
                            );
                          },
                        );
                      },
                      icon: const Icon(LucideIcons.filter),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      showBorder: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 1),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/styled_text_field.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

class SearchToolbar extends StatefulWidget {
  const SearchToolbar({super.key});

  @override
  State<SearchToolbar> createState() => _SearchToolbarState();
}

class _SearchToolbarState extends State<SearchToolbar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showClearButton = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _showClearButton = false;
    });
    context.read<UpcomingGamesCubit>().updateNameQuery('');
    context.read<UpcomingGamesCubit>().searchGames();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpcomingGamesCubit, UpcomingGamesState>(
      listener: (_, state) {
        if (state.nameQuery.isEmpty && _searchController.text.isNotEmpty) {
          _searchController.clear();
          setState(() {
            _showClearButton = false;
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacings.xs,
        ).copyWith(
          bottom: context.spacings.xs,
        ),
        child: Semantics(
          label: 'Search for games',
          hint: 'Enter game title to search',
          child: StyledTextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            autofocus: false,
            leading: const Icon(Icons.search),
            trailing: _showClearButton
                ? Semantics(
                    label: 'Clear search field',
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.clear),
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
              await context.read<UpcomingGamesCubit>().updateNameQuery(value);
              context.read<UpcomingGamesCubit>().searchGames();
            },
          ),
        ),
      ),
    );
  }
}

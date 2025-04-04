import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:moon_design/moon_design.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

class SearchToolbar extends StatelessWidget {
  const SearchToolbar({super.key});

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
                  autofocus: false,
                  leading: Icon(Icons.search),
                  hintText: 'Search for games',
                  onChanged: (value) async {
                    await context
                        .read<UpcomingGamesCubit>()
                        .updateNameQuery(value);
                    context.read<UpcomingGamesCubit>().searchGames(value);
                  },
                ),
              ),
              Visibility(
                visible: false,
                child: Row(
                  children: [
                    SizedBox(width: context.spacings.xs),
                    MoonButton.icon(
                      buttonSize: MoonButtonSize.sm,
                      onTap: () {},
                      icon: const Icon(LucideIcons.filter),
                      backgroundColor: Colors.white,
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

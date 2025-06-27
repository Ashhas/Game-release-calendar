import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/presentation/common/state/game_update_cubit/game_update_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/game_update_cubit/game_update_state.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

class GameUpdateStatusIndicator extends StatelessWidget {
  const GameUpdateStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameUpdateCubit, GameUpdateState>(
      builder: (context, state) {
        return state.when(
          idle: () => const SizedBox.shrink(),
          loading: (total, processed) => Padding(
            padding: EdgeInsets.only(right: context.spacings.m),
            child: Semantics(
              label: 'Syncing games, $processed of $total processed',
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
            ),
          ),
          completed: () => Padding(
            padding: EdgeInsets.only(right: context.spacings.m),
            child: Semantics(
              label: 'Games synced successfully, no updates found',
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
            ),
          ),
          updated: () => Padding(
            padding: EdgeInsets.only(right: context.spacings.m),
            child: Semantics(
              label: 'Games updated successfully, new changes found',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Updated!',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: context.spacings.xs),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.orange,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          error: (message) => Padding(
            padding: EdgeInsets.only(right: context.spacings.m),
            child: Semantics(
              label: 'Sync failed: $message',
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/presentation/common/state/game_update_cubit/game_update_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/game_update_cubit/game_update_state.dart';
import 'package:game_release_calendar/src/presentation/common/toast/toast_helper.dart';

/// Global listener for app-wide state changes that trigger toast notifications
/// This widget listens to multiple cubits and shows appropriate toasts
class GlobalStateListener extends StatefulWidget {
  const GlobalStateListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<GlobalStateListener> createState() => _GlobalStateListenerState();
}

class _GlobalStateListenerState extends State<GlobalStateListener> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GameUpdateCubit, GameUpdateState>(
          listener: _handleGameUpdateState,
        ),
      ],
      child: widget.child,
    );
  }

  // ignore: avoid_unused_parameters
  void _handleGameUpdateState(BuildContext _, GameUpdateState state) {
    state.when(
      idle: () {
        // No action needed
      },
      loading: (_, processedGames) {
        // Only show toast when starting (processedGames == 0)
        if (processedGames == 0) {
          ToastHelper.showToast(
            'Syncing games...',
            icon: Icons.sync,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            duration: const Duration(seconds: 5),
          );
        }
      },
      completed: () {
        ToastHelper.showToast(
          'Games synced!',
          icon: Icons.check_circle,
          backgroundColor: Theme.of(context).colorScheme.primary,
          textColor: Theme.of(context).colorScheme.onPrimary,
          duration: const Duration(seconds: 5),
        );
      },
      updated: () {
        ToastHelper.showToast(
          'Games updated!',
          icon: Icons.update,
          backgroundColor: Theme.of(context).colorScheme.primary,
          textColor: Theme.of(context).colorScheme.onPrimary,
          duration: const Duration(seconds: 5),
        );
      },
      error: (message) {
        ToastHelper.showToast(
          'Sync failed: $message',
          icon: Icons.close,
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Theme.of(context).colorScheme.onError,
          duration: const Duration(seconds: 5),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/domain/models/game_update_log.dart';
import 'package:game_release_calendar/src/domain/models/platform.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_state.dart';
import 'package:game_release_calendar/src/presentation/game_updates/state/game_updates_cubit.dart';
import 'package:game_release_calendar/src/presentation/game_updates/state/game_updates_state.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:riverpod/riverpod.dart';

class GameUpdatesContainer extends StatelessWidget {
  const GameUpdatesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Game Updates',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Release Today'),
              Tab(text: "What's New"),
            ],
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 3,
            dividerColor: Colors.transparent,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const TabBarView(
          children: [
            _ReleaseTodayTab(),
            _WhatsNewTab(),
          ],
        ),
      ),
    );
  }
}

class _ReleaseTodayTab extends StatelessWidget {
  const _ReleaseTodayTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return state.notifications.when(
          data: (notifications) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);

            // Filter games releasing today
            final todaysReleases = notifications.where((notification) {
              final reminder = GameReminder.fromJson(jsonDecode(notification.payload!));
              final releaseDate = reminder.releaseDate.date;
              if (releaseDate == null) return false;

              final gameReleaseDate = DateTime.fromMillisecondsSinceEpoch(releaseDate * 1000);
              final gameDate = DateTime(gameReleaseDate.year, gameReleaseDate.month, gameReleaseDate.day);
              return gameDate.isAtSameMomentAs(today);
            }).toList();

            final todaysReleaseReminders = todaysReleases
                .map((n) => GameReminder.fromJson(jsonDecode(n.payload!)))
                .toList();

            if (todaysReleaseReminders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.today_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: context.spacings.m),
                    Text(
                      'No games releasing today',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: context.spacings.s),
                    Text(
                      'Check back tomorrow for new releases!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.spacings.m,
                    context.spacings.m,
                    context.spacings.m,
                    context.spacings.s,
                  ),
                  child: Text(
                    'Here are the games you\'re following that are releasing today.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      left: context.spacings.m,
                      right: context.spacings.m,
                      bottom: context.spacings.xl,
                    ),
                    itemCount: todaysReleaseReminders.length,
                    separatorBuilder: (_, __) => SizedBox(height: context.spacings.m),
                    itemBuilder: (_, index) {
                      final reminder = todaysReleaseReminders[index];

                      return _GameUpdateCard(
                        gameReminder: reminder,
                        showUpdateType: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameDetailView(game: reminder.gamePayload),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Error loading releases: $error'),
          ),
        );
      },
    );
  }
}

class _WhatsNewTab extends StatefulWidget {
  const _WhatsNewTab();

  @override
  State<_WhatsNewTab> createState() => _WhatsNewTabState();
}

class _WhatsNewTabState extends State<_WhatsNewTab> {
  @override
  void initState() {
    super.initState();
    // Load recent update logs when tab is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameUpdatesCubit>().loadRecentUpdateLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameUpdatesCubit, GameUpdatesState>(
      builder: (context, state) {
        return state.updateLogs.when(
          data: (updateLogs) {
            if (updateLogs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.update,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: context.spacings.m),
                    Text(
                      'No game updates yet',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: context.spacings.s),
                    Text(
                      'Updates will appear here when games are modified',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.spacings.m,
                    context.spacings.m,
                    context.spacings.m,
                    context.spacings.s,
                  ),
                  child: Text(
                    'Keep up with the latest on your followed games.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      left: context.spacings.m,
                      right: context.spacings.m,
                      bottom: context.spacings.xl,
                    ),
                    itemCount: updateLogs.length,
                    separatorBuilder: (_, __) => SizedBox(height: context.spacings.m),
                    itemBuilder: (_, index) {
                      final updateLog = updateLogs[index];

                      return _GameUpdateCard(
                        gameUpdateLog: updateLog,
                        showUpdateType: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameDetailView(game: updateLog.gamePayload),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(height: context.spacings.m),
                Text(
                  'Error loading updates',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                SizedBox(height: context.spacings.s),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GameUpdateCard extends StatelessWidget {
  final GameReminder? gameReminder;
  final GameUpdateLog? gameUpdateLog;
  final bool showUpdateType;
  final VoidCallback onTap;

  const _GameUpdateCard({
    this.gameReminder,
    this.gameUpdateLog,
    this.showUpdateType = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine data source and extract values
    final displayName = gameUpdateLog?.gameName ??
                       gameReminder?.gameName ?? '';

    final game = gameUpdateLog?.gamePayload ?? gameReminder?.gamePayload;
    final coverUrl = game?.cover?.url;

    // Format update type
    final displayUpdateType = gameUpdateLog?.updateType.displayText ?? '';

    // Format subtitle based on context
    String? subtitle;
    final updateLog = gameUpdateLog;
    if (showUpdateType && updateLog != null) {
      // For What's New tab: show detection date
      final dateFormat = DateFormat('MMM d, yyyy');
      subtitle = 'Updated ${dateFormat.format(updateLog.detectedAt)}';
    } else if (!showUpdateType && gameReminder != null) {
      // For Release Today tab: show platform info if available
      subtitle = _formatPlatformSubtitle(game?.platforms);
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.all(Radius.circular(context.spacings.s)),
        border: Border.fromBorderSide(BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        )),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.all(Radius.circular(context.spacings.s)),
        child: Padding(
          padding: EdgeInsets.all(context.spacings.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Update type header (only show if requested)
              if (showUpdateType && displayUpdateType.isNotEmpty) ...[
                Text(
                  displayUpdateType,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: context.spacings.s),
              ],
              // Game info row
              Row(
                children: [
                  // Game image
                  Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.all(Radius.circular(context.spacings.xxs)),
                      border: Border.fromBorderSide(BorderSide(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                      )),
                    ),
                    child: coverUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(context.spacings.xxs)),
                            child: Image.network(
                              'https:${coverUrl.replaceAll('t_thumb', 't_cover_small')}',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.videogame_asset,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                size: 24,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.videogame_asset,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                  ),
                  SizedBox(width: context.spacings.m),
                  // Game info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: context.spacings.xxs),
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: context.spacings.s),
                  // Arrow icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _formatPlatformSubtitle(List<Platform>? platforms) {
    if (platforms == null || platforms.isEmpty) return null;

    if (platforms.length == 1) {
      return platforms.first.abbreviation ?? platforms.first.name ?? '';
    }

    if (platforms.length == 2) {
      final names = platforms.map((p) => p.abbreviation ?? p.name ?? '').where((name) => name.isNotEmpty).toList();
      return names.join(' • ');
    }

    final firstTwo = platforms.take(2).map((p) => p.abbreviation ?? p.name ?? '').where((name) => name.isNotEmpty).toList();
    return '${firstTwo.join(' • ')} & ${platforms.length - 2} more';
  }
}

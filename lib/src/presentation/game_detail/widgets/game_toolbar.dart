part of '../game_detail_view.dart';

class GameToolbar extends StatefulWidget {
  const GameToolbar({
    required this.game,
    super.key,
  });

  final Game game;

  @override
  State<GameToolbar> createState() => _GameToolbarState();
}

class _GameToolbarState extends State<GameToolbar> {
  bool _isScheduled = false;

  @override
  void initState() {
    super.initState();

    _isScheduled = context.read<RemindersCubit>().hasScheduledNotifications(
          widget.game.id,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            if (_isScheduled) {
              setState(() {
                context
                    .read<RemindersCubit>()
                    .cancelNotification(widget.game.id);
                _isScheduled = false;
              });
            } else {
              setState(() {
                // context
                //     .read<RemindersCubit>()
                //     .scheduleNotification(widget.game);
                _isScheduled = true;
              });
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isScheduled
                  ? const Icon(Icons.notifications_active)
                  : const Icon(Icons.notifications_outlined),
              SizedBox(height: 4),
              Text('Reminder'),
            ],
          ),
        ),
        SizedBox(width: context.spacings.l),
        InkWell(
          onTap: () => UrlHelper.openUrl(
            widget.game.url,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.web,
                size: 28,
              ),
              SizedBox(height: context.spacings.xxs),
              const Text('Website'),
            ],
          ),
        ),
      ],
    );
  }
}

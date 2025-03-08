part of '../reminders_container.dart';

class GameReminderTile extends StatefulWidget {
  final PendingNotificationRequest reminder;

  const GameReminderTile({
    Key? key,
    required this.reminder,
  }) : super(key: key);

  @override
  _GameReminderTileState createState() => _GameReminderTileState();
}

class _GameReminderTileState extends State<GameReminderTile> {
  late ScheduledNotificationPayload _notification;

  @override
  void initState() {
    super.initState();
    _notification = ScheduledNotificationPayload.fromJson(
      jsonDecode(widget.reminder.payload!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              _notification.game.releaseDates!.first.human.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(width: context.spacings.m),
          Flexible(
            flex: 3,
            child: Text(
              _notification.gameName,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameDetailView(game: _notification.game),
        ),
      ),
    );
  }
}

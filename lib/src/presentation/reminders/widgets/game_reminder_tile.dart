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
  late ScheduledNotification notification;
  late tz.TZDateTime releaseDate;
  late ReleaseDateCategory releaseDateCategory;

  @override
  void initState() {
    super.initState();
    notification = ScheduledNotification.fromJson(
      jsonDecode(widget.reminder.payload!),
    );
    releaseDate = notification.scheduledDateTime;
    releaseDateCategory = notification.releaseDateCategory;
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
              notification.game.releaseDates!.first.human.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(width: context.spacings.m),
          Flexible(
            flex: 3,
            child: Text(
              notification.gameName,
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
          builder: (_) => GameDetailView(game: notification.game),
        ),
      ),
    );
  }
}

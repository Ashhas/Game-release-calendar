part of '../reminders_container.dart';

class GameReminderTile extends StatefulWidget {
  final GameReminder reminder;

  const GameReminderTile({Key? key, required this.reminder}) : super(key: key);

  @override
  _GameReminderTileState createState() => _GameReminderTileState();
}

class _GameReminderTileState extends State<GameReminderTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              widget.reminder.releaseDate.human.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(width: context.spacings.m),
          Flexible(
            flex: 3,
            child: Text(
              widget.reminder.gameName,
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
          builder: (_) => GameDetailView(game: widget.reminder.gamePayload),
        ),
      ),
    );
  }
}

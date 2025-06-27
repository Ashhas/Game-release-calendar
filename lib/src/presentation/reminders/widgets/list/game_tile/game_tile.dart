part of '../reminder_list_view.dart';

class GameTile extends StatelessWidget {
  const GameTile({
    required this.reminder,
    super.key,
  });

  final GameReminder reminder;

  String _formatReleaseDate(int? timestamp) {
    if (timestamp == null) {
      return 'TBD';
    }
    final dateTime = DateTimeConverter.secondSinceEpochToDateTime(timestamp);
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FadeInImage.assetNetwork(
        placeholder: 'assets/images/placeholder_210_284.png',
        image: reminder.gamePayload.cover != null
            ? reminder.gamePayload.cover!.imageUrl()
            : Constants.placeholderImageUrl,
        fadeInDuration: const Duration(milliseconds: 100),
        imageErrorBuilder: (_, __, ___) =>
            Image.asset('assets/images/placeholder_210_284.png'),
      ),
      title: Text(reminder.gameName),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Release date: ${_formatReleaseDate(reminder.releaseDate.date)}'),
          if (reminder.releaseDate.platform != null)
            Wrap(
              spacing: 4.0,
              children: [
                Chip(
                  label: Text(
                    reminder.releaseDate.platform?.abbreviation ??
                        reminder.releaseDate.platform?.name ??
                        'N/A',
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () {
          context.read<RemindersCubit>().removeReminder(reminder.id);
        },
        tooltip: 'Remove reminder',
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameDetailView(game: reminder.gamePayload),
        ),
      ),
    );
  }
}

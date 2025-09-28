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
    final dateTime = DateUtilities.secondSinceEpochToDateTime(timestamp);
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 56,
        height: 94,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/placeholder_210_284.png',
            image: reminder.gamePayload.cover != null
                ? reminder.gamePayload.cover!.imageUrl()
                : Constants.placeholderImageUrl,
            fadeInDuration: const Duration(milliseconds: 100),
            fit: BoxFit.cover,
            imageErrorBuilder: (_, __, ___) => Image.asset(
              'assets/images/placeholder_210_284.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
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
        icon: const Icon(Icons.notifications_off_outlined),
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

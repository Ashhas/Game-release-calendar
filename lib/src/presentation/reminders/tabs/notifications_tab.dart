part of '../reminders_container.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (_, state) {
        return state.notifications.when(
          data: (notifications) {
            final notificationsList = notifications.sortedBy((notification) =>
                GameReminder.fromJson(jsonDecode(notification.payload!))
                    .releaseDate
                    .date ??
                0);

            if (notificationsList.isEmpty) {
              return Center(
                child: Text(
                  'No reminders set',
                ),
              );
            }

            return ListView.builder(
              itemCount: notificationsList.length,
              itemBuilder: (_, index) {
                final notification = notificationsList[index];
                final reminder = GameReminder.fromJson(
                  jsonDecode(notification.payload!),
                );
                final formattedDate = DateFormat('h:mm a, MMM d y');

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Text(
                          reminder.gameName,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      SizedBox(width: context.spacings.m),
                      Flexible(
                        flex: 1,
                        child: Text(
                          reminder.notificationDate != null
                              ? "${formattedDate.format(reminder.notificationDate!)}"
                              : 'TBD',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {},
                );
              },
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          error: (error, _) {
            return Text('Error: $error');
          },
        );
      },
    );
  }
}

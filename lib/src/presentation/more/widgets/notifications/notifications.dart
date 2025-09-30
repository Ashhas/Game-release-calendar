part of '../../more_container.dart';

class _NotificationListWidget extends StatelessWidget {
  const _NotificationListWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: EdgeInsets.symmetric(
        horizontal: context.spacings.m,
        vertical: context.spacings.s,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.all(Radius.circular(context.spacings.s)),
        border: Border.fromBorderSide(BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        )),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(context.spacings.m),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.spacings.s),
                topRight: Radius.circular(context.spacings.s),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: context.spacings.s),
                Text(
                  'Scheduled Notifications',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (_, state) {
                return state.notifications.when(
                  data: (notifications) {
                    final notificationsList = notifications.sortedBy(
                        (notification) =>
                            GameReminder.fromJson(
                                    jsonDecode(notification.payload!))
                                .releaseDate
                                .date ??
                            0);

                    if (notificationsList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 48,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            SizedBox(height: context.spacings.s),
                            Text(
                              'No reminders set',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Stack(
                      children: [
                        ListView.separated(
                          padding: EdgeInsets.all(context.spacings.s),
                          itemCount: notificationsList.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            thickness: 0.3,
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                          ),
                      itemBuilder: (_, index) {
                        final notification = notificationsList[index];
                        final reminder = GameReminder.fromJson(
                          jsonDecode(notification.payload!),
                        );
                        final formattedDate = DateFormat('h:mm a, MMM d y');

                        return Container(
                          padding: EdgeInsets.symmetric(
                            vertical: context.spacings.s,
                            horizontal: context.spacings.xs,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: context.spacings.s),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reminder.gameName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    if (reminder.notificationDate != null)
                                      Text(
                                        formattedDate
                                            .format(reminder.notificationDate!),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Top scroll indicator
                    if (notificationsList.length > 3)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 16,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).colorScheme.surfaceContainerHighest,
                                Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 3,
                              margin: EdgeInsets.only(top: context.spacings.xxs),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Bottom scroll indicator
                    if (notificationsList.length > 3)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 16,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Theme.of(context).colorScheme.surfaceContainerHighest,
                                Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 3,
                              margin: EdgeInsets.only(bottom: context.spacings.xxs),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  error: (_, __) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          SizedBox(height: context.spacings.s),
                          Text(
                            'Error loading notifications',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with WidgetsBindingObserver {
  bool _isGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissionStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.notification.status;
    setState(() {
      _isGranted = status.isGranted;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionStatus();
    }
  }

  Future<void> _openSettingsAndCheckPermission() async {
    await openAppSettings();
    // Permission will be rechecked automatically when returning to the app
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        children: [
                ListTile(
                  title: const Text('Enable notifications'),
                  subtitle: const Text('Change in Settings -> Notifications'),
                  trailing: Switch(
                    value: _isGranted,
                    onChanged: (_) {},
                  ),
                  onTap: () {
                    _openSettingsAndCheckPermission();
                  },
                ),
                ListTile(
                  title: const Text('Schedule'),
                  subtitle: Text(
                      'Default notification time ${_twoDigits(Constants.defaultNotificationHour)}:${_twoDigits(Constants.defaultNotificationMinute)}'),
                  onTap: () {},
                ),
                SizedBox(height: context.spacings.m),
                const _NotificationListWidget(),
                SizedBox(height: context.spacings.m),
        ],
      ),
    );
  }

  String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }
}

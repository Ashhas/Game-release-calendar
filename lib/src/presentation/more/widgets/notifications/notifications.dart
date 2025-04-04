part of '../../more_container.dart';

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
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
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
          Divider(height: 0, thickness: 0.5),
          Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: context.spacings.m),
                  const Text('Schedule'),
                  Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
          ListTile(
            title: const Text('Default notification time'),
            subtitle: Text(
              '${_twoDigits(Constants.defaultNotificationHour)}:${_twoDigits(Constants.defaultNotificationMinute)}',
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }

  String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }
}

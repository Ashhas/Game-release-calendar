import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';
import 'package:riverpod/riverpod.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit({
    required NotificationClient notificationClient,
  })  : _notificationClient = notificationClient,
        super(RemindersState());

  final NotificationClient _notificationClient;

  Future<void> retrievePendingNotifications() async {
    final pendingNotifications =
        await _notificationClient.retrievePendingNotifications();

    emit(
      state.copyWith(
        reminders: AsyncValue.data(pendingNotifications),
      ),
    );
  }
}

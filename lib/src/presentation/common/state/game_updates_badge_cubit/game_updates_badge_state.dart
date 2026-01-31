class GameUpdatesBadgeState {
  const GameUpdatesBadgeState({
    this.shouldShowBadge = false,
    this.lastReadDate,
    this.todayReleasesCount = 0,
    this.todayUpdateLogsCount = 0,
  });

  final bool shouldShowBadge;
  final DateTime? lastReadDate;
  final int todayReleasesCount;
  final int todayUpdateLogsCount;

  GameUpdatesBadgeState copyWith({
    bool? shouldShowBadge,
    DateTime? lastReadDate,
    int? todayReleasesCount,
    int? todayUpdateLogsCount,
  }) {
    return GameUpdatesBadgeState(
      shouldShowBadge: shouldShowBadge ?? this.shouldShowBadge,
      lastReadDate: lastReadDate ?? this.lastReadDate,
      todayReleasesCount: todayReleasesCount ?? this.todayReleasesCount,
      todayUpdateLogsCount: todayUpdateLogsCount ?? this.todayUpdateLogsCount,
    );
  }

  bool get hasContent => todayReleasesCount > 0 || todayUpdateLogsCount > 0;

  bool get isReadToday {
    if (lastReadDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final readDate = DateTime(
      lastReadDate!.year,
      lastReadDate!.month,
      lastReadDate!.day,
    );

    return readDate.isAtSameMomentAs(today) || readDate.isAfter(today);
  }
}

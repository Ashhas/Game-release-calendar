import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/theme/context_extensions.dart';

class SectionHeader extends StatelessWidget {
  final DateTime date;

  const SectionHeader({
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.spacings.xs),
      child: Text(
        '${date.day}/${date.month}/${date.year}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

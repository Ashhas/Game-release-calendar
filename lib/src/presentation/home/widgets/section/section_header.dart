import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final DateTime date;

  const SectionHeader({
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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

import 'package:flutter/material.dart';

/// A circular color preview widget for theme selection
class ColorPreview extends StatelessWidget {
  const ColorPreview({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.fromBorderSide(BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        )),
      ),
    );
  }
}
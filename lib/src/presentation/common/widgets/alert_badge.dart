import 'package:flutter/material.dart';

class AlertBadge extends StatelessWidget {
  const AlertBadge({
    super.key,
    required this.child,
    this.showBadge = false,
  });

  final Widget child;
  final bool showBadge;

  static const double _badgeSize = 8.0;
  static const double _badgeTopOffset = 0.0;
  static const double _badgeRightOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showBadge)
          Positioned(
            top: _badgeTopOffset,
            right: _badgeRightOffset,
            child: Container(
              width: _badgeSize,
              height: _badgeSize,
              decoration: BoxDecoration(
                color: colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
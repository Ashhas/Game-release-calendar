import 'package:flutter/material.dart';

/// Size options for StyledIconButton
enum StyledButtonSize {
  small,
  medium,
  large,
}

/// A styled icon button with border and background
/// Replaces MoonButton.icon with native Flutter components
class StyledIconButton extends StatelessWidget {
  const StyledIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = StyledButtonSize.medium,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.showBorder = true,
    this.tooltip,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final StyledButtonSize size;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final bool showBorder;
  final String? tooltip;
  final bool enabled;

  double get _iconSize {
    switch (size) {
      case StyledButtonSize.small:
        return 18;
      case StyledButtonSize.medium:
        return 24;
      case StyledButtonSize.large:
        return 28;
    }
  }

  double get _buttonSize {
    switch (size) {
      case StyledButtonSize.small:
        return 36;
      case StyledButtonSize.medium:
        return 44;
      case StyledButtonSize.large:
        return 52;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case StyledButtonSize.small:
        return const EdgeInsets.all(6);
      case StyledButtonSize.medium:
        return const EdgeInsets.all(8);
      case StyledButtonSize.large:
        return const EdgeInsets.all(10);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = enabled && onTap != null;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
    final effectiveIconColor = iconColor ??
        (isEnabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.38));
    final effectiveBorderColor = borderColor ??
        (isEnabled ? colorScheme.outline : colorScheme.outline.withValues(alpha: 0.12));

    Widget button = Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: showBorder
              ? Border.fromBorderSide(BorderSide(
                  color: effectiveBorderColor,
                  width: 1,
                ))
              : null,
        ),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Container(
            width: _buttonSize,
            height: _buttonSize,
            padding: _padding,
            child: Icon(
              icon,
              size: _iconSize,
              color: effectiveIconColor,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }

  /// Factory constructor for creating icon-only button
  factory StyledIconButton.icon({
    Key? key,
    required IconData icon,
    required VoidCallback? onTap,
    StyledButtonSize buttonSize = StyledButtonSize.medium,
    Color? backgroundColor,
    Color? iconColor,
    Color? borderColor,
    bool showBorder = true,
    String? tooltip,
    bool enabled = true,
  }) {
    return StyledIconButton(
      key: key,
      icon: icon,
      onTap: onTap,
      size: buttonSize,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      borderColor: borderColor,
      showBorder: showBorder,
      tooltip: tooltip,
      enabled: enabled,
    );
  }
}
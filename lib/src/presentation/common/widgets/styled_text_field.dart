import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/theme/theme_extensions.dart';

/// A styled text field with rounded corners and optional leading/trailing widgets
/// Replaces MoonTextInput with native Flutter components
class StyledTextField extends StatelessWidget {
  const StyledTextField({
    super.key,
    this.controller,
    this.hintText,
    this.leading,
    this.trailing,
    this.onChanged,
    this.autofocus = false,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.focusNode,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? leading;
  final Widget? trailing;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: autofocus,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.primary,
            ),
        prefixIcon: leading != null
            ? IconTheme(
                data: IconThemeData(color: colorScheme.primary),
                child: leading!,
              )
            : null,
        suffixIcon: trailing != null
            ? IconTheme(
                data: IconThemeData(color: colorScheme.primary),
                child: trailing!,
              )
            : null,
        filled: true,
        fillColor: colorScheme.primaryContainer,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.spacings.s,
          vertical: context.spacings.xs,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
      ),
    );
  }
}
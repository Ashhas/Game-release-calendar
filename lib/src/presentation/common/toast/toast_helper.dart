import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'package:game_release_calendar/src/presentation/common/toast/custom_toast.dart';

/// Helper class for showing consistent toast notifications throughout the app
class ToastHelper {
  // Prevent instantiation
  const ToastHelper._();

  /// Show a custom toast with full control over appearance
  static ToastificationItem showToast(
    String title, {
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    Duration? duration,
  }) {
    // Dismiss all existing toasts to prevent stacking
    toastification.dismissAll();

    return toastification.showCustom(
      alignment: Alignment.bottomCenter,
      autoCloseDuration: duration,
      builder: (_, __) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: CustomToast(
            title: title,
            icon: icon,
            backgroundColor: backgroundColor,
            textColor: textColor,
          ),
        );
      },
    );
  }
}

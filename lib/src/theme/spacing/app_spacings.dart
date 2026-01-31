// ignore_for_file: prefer-trailing-comma

import 'dart:ui';

import 'package:flutter/material.dart';

/// Extension on [ThemeData] for adding multiple spacing values
@immutable
class AppSpacings extends ThemeExtension<AppSpacings> {
  const AppSpacings({
    required this.xxs,
    required this.xs,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  /// default: 4.0
  final double xxs;

  /// default: 8.0
  final double xs;

  /// default: 12.0
  final double s;

  /// default: 16.0
  final double m;

  /// default: 20.0
  final double l;

  /// default: 24.0
  final double xl;

  /// default: 32.0
  final double xxl;

  /// default: 40.0
  final double xxxl;

  /// Default [ThemeData] extension
  static const defaultValues = AppSpacings(
    xxs: 4,
    xs: 8,
    s: 12,
    m: 16,
    l: 20,
    xl: 24,
    xxl: 32,
    xxxl: 40,
  );

  @override
  // ignore: long-parameter-list
  ThemeExtension<AppSpacings> copyWith({
    double? xxs,
    double? xs,
    double? s,
    double? m,
    double? l,
    double? xl,
    double? xxl,
    double? xxxl,
  }) => AppSpacings(
    xxs: xxs ?? this.xxs,
    xs: xs ?? this.xs,
    s: s ?? this.s,
    m: m ?? this.m,
    l: l ?? this.l,
    xl: xl ?? this.xl,
    xxl: xxl ?? this.xxl,
    xxxl: xxxl ?? this.xxxl,
  );

  @override
  ThemeExtension<AppSpacings> lerp(
    ThemeExtension<AppSpacings>? other,
    double t,
  ) {
    if (other is! AppSpacings) {
      return this;
    }
    return AppSpacings(
      xxs: lerpDouble(xxs, other.xxs, t)!,
      xs: lerpDouble(xs, other.xs, t)!,
      s: lerpDouble(s, other.s, t)!,
      m: lerpDouble(m, other.m, t)!,
      l: lerpDouble(l, other.l, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
      xxxl: lerpDouble(xxxl, other.xxxl, t)!,
    );
  }
}

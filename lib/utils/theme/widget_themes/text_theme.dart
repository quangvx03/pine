import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class PTextTheme{
  PTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: PColors.dark, fontFamily: 'Cabin'),
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600, color: PColors.dark, fontFamily: 'Cabin'),
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w600, color: PColors.dark, fontFamily: 'Cabin'),

    titleLarge: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600, color: PColors.dark, fontFamily: 'Cabin'),
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: PColors.dark, fontFamily: 'Cabin'),
    titleSmall: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: PColors.dark, fontFamily: 'Cabin'),

    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: PColors.dark, fontFamily: 'Cabin'),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: PColors.dark, fontFamily: 'Cabin'),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: PColors.dark.withValues(alpha: 0.5), fontFamily: 'Cabin'),

    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: PColors.dark, fontFamily: 'Cabin'),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: PColors.dark.withValues(alpha: 0.5), fontFamily: 'Cabin'),

  );
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: PColors.light, fontFamily: 'Cabin'),
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600, color: PColors.light, fontFamily: 'Cabin'),
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w600, color: PColors.light, fontFamily: 'Cabin'),

    titleLarge: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600, color: PColors.light, fontFamily: 'Cabin'),
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: PColors.light, fontFamily: 'Cabin'),
    titleSmall: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: PColors.light, fontFamily: 'Cabin'),

    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: PColors.light, fontFamily: 'Cabin'),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: PColors.light, fontFamily: 'Cabin'),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: PColors.light.withValues(alpha: 0.5), fontFamily: 'Cabin'),

    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: PColors.light, fontFamily: 'Cabin'),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: PColors.light.withValues(alpha: 0.5), fontFamily: 'Cabin'),
  );
}
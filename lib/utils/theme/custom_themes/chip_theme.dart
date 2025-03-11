import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class PChipTheme{
  PChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: PColors.grey.withValues(alpha: 0.4),
    labelStyle: const TextStyle(color: PColors.black, fontFamily: 'Cabin'),
    selectedColor: PColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: PColors.white,
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    disabledColor: PColors.darkGrey,
    labelStyle: const TextStyle(color: PColors.white, fontFamily: 'Cabin'),
    selectedColor: PColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: PColors.white,
  );
}
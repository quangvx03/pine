import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class PChipTheme {
  PChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    checkmarkColor: PColors.white,
    selectedColor: PColors.primary,
    disabledColor: PColors.grey.withValues(alpha: 0.4),
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    labelStyle: const TextStyle(color: PColors.black, fontFamily: 'Cabin'),
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    checkmarkColor: PColors.white,
    selectedColor: PColors.primary,
    disabledColor: PColors.darkerGrey,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    labelStyle: TextStyle(color: PColors.white, fontFamily: 'Cabin'),
  );
}

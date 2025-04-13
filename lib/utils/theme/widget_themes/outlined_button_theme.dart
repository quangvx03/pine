import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class POutLinedButtonTheme{
  POutLinedButtonTheme._();

  static final lightOutLinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: PColors.dark,
      side: const BorderSide(color: PColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: PColors.black, fontWeight: FontWeight.w600, fontFamily: 'Cabin'),
      padding: const EdgeInsets.symmetric(vertical: PSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PSizes.buttonRadius)),
    ),
  );

  static final darkOutLinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: PColors.light,
      side: const BorderSide(color: PColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: PColors.textWhite, fontWeight: FontWeight.w600, fontFamily: 'Cabin'),
      padding: const EdgeInsets.symmetric(vertical: PSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PSizes.buttonRadius)),
    ),
  );
}
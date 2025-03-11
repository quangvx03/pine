import 'package:flutter/material.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';

class PElevatedButtonTheme{
  PElevatedButtonTheme._();
  //
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: PColors.light,
      backgroundColor: PColors.primary,
      disabledForegroundColor: PColors.darkGrey,
      disabledBackgroundColor: PColors.buttonDisabled,
      side: const BorderSide(color: PColors.primary),
      padding: const EdgeInsets.symmetric(vertical: PSizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: PColors.textWhite, fontWeight: FontWeight.w600, fontFamily: 'Cabin'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PSizes.buttonRadius)),
    )
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: PColors.light,
        backgroundColor: PColors.primary,
        disabledForegroundColor: PColors.darkGrey,
        disabledBackgroundColor: PColors.darkerGrey,
        side: const BorderSide(color: PColors.primary),
        padding: const EdgeInsets.symmetric(vertical: PSizes.buttonHeight),
        textStyle: const TextStyle(fontSize: 16, color: PColors.white, fontWeight: FontWeight.w600, fontFamily: 'Cabin'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PSizes.buttonRadius)),
      )
  );
}
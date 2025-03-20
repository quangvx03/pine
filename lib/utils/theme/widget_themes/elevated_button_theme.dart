import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class PElevatedButtonTheme {
  PElevatedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightElevatedButtonTheme  = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: PColors.light,
      backgroundColor: PColors.primary,
      disabledForegroundColor: PColors.darkGrey,
      disabledBackgroundColor: PColors.buttonDisabled,
      side: const BorderSide(color: PColors.primary),
      padding: const EdgeInsets.symmetric(vertical: PSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PSizes.buttonRadius)),
      textStyle: const TextStyle(fontSize: 16, color: PColors.textWhite, fontWeight: FontWeight.w500, fontFamily: 'Urbanist'),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: PColors.light,
      backgroundColor: PColors.primary,
      disabledForegroundColor: PColors.darkGrey,
      disabledBackgroundColor: PColors.darkerGrey,
      side: const BorderSide(color: PColors.primary),
      padding: const EdgeInsets.symmetric(vertical: PSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PSizes.buttonRadius)),
      textStyle: const TextStyle(fontSize: 16, color: PColors.textWhite, fontWeight: FontWeight.w600, fontFamily: 'Urbanist'),
    ),
  );
}

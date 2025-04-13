import 'package:flutter/material.dart';
import 'package:pine_admin_panel/utils/theme/widget_themes/appbar_theme.dart';
import 'package:pine_admin_panel/utils/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:pine_admin_panel/utils/theme/widget_themes/checkbox_theme.dart';
import 'package:pine_admin_panel/utils/theme/widget_themes/chip_theme.dart';
import 'package:pine_admin_panel/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:pine_admin_panel/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:pine_admin_panel/utils/theme/widget_themes/text_field_theme.dart';
import 'package:pine_admin_panel/utils/theme/widget_themes/text_theme.dart';

import '../constants/colors.dart';

class PAppTheme {
  PAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Cabin',
      disabledColor: PColors.grey,
      brightness: Brightness.light,
      primaryColor: PColors.primary,
      textTheme: PTextTheme.lightTextTheme,
      chipTheme: PChipTheme.lightChipTheme,
      scaffoldBackgroundColor: PColors.primaryBackground,
      appBarTheme: PAppBarTheme.lightAppBarTheme,
      checkboxTheme: PCheckboxTheme.lightCheckboxTheme,
      bottomSheetTheme: PBottomSheetTheme.lightBottomSheetTheme,
      elevatedButtonTheme: PElevatedButtonTheme.lightElevatedButtonTheme,
      outlinedButtonTheme: POutLinedButtonTheme.lightOutLinedButtonTheme,
      inputDecorationTheme: PTextFormFieldTheme.lightInputDecorationTheme,
      colorScheme: ColorScheme.light(
        primary: PColors.primary,
        surface: PColors.white,
        error: PColors.error,
        onPrimary: PColors.textWhite,
        onSecondary: PColors.textPrimary,
        onSurface: PColors.textPrimary,
        onError: PColors.textWhite,
      ));

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Cabin',
      disabledColor: PColors.grey,
      brightness: Brightness.dark,
      primaryColor: PColors.primary,
      textTheme: PTextTheme.darkTextTheme,
      chipTheme: PChipTheme.darkChipTheme,
      scaffoldBackgroundColor: PColors.black,
      appBarTheme: PAppBarTheme.darkAppBarTheme,
      checkboxTheme: PCheckboxTheme.darkCheckboxTheme,
      bottomSheetTheme: PBottomSheetTheme.darkBottomSheetTheme,
      elevatedButtonTheme: PElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: POutLinedButtonTheme.darkOutLinedButtonTheme,
      inputDecorationTheme: PTextFormFieldTheme.darkInputDecorationTheme,
      colorScheme: ColorScheme.dark(
        primary: PColors.primary,
        surface: PColors.darkerGrey,
        error: PColors.error,
        onPrimary: PColors.textWhite,
        onSecondary: PColors.textWhite,
        onSurface: PColors.textWhite,
        onError: PColors.textWhite,
      ));
}
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'widget_themes/appbar_theme.dart';
import 'widget_themes/bottom_sheet_theme.dart';
import 'widget_themes/checkbox_theme.dart';
import 'widget_themes/chip_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/outlined_button_theme.dart';
import 'widget_themes/text_field_theme.dart';
import 'widget_themes/text_theme.dart';

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
    appBarTheme: PAppBarTheme.lightAppBarTheme,
    checkboxTheme: PCheckboxTheme.lightCheckboxTheme,
    scaffoldBackgroundColor: PColors.primaryBackground,
    bottomSheetTheme: PBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: PElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: POutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: PTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Cabin',
    disabledColor: PColors.grey,
    brightness: Brightness.dark,
    primaryColor: PColors.primary,
    textTheme: PTextTheme.darkTextTheme,
    chipTheme: PChipTheme.darkChipTheme,
    appBarTheme: PAppBarTheme.darkAppBarTheme,
    checkboxTheme: PCheckboxTheme.darkCheckboxTheme,
    scaffoldBackgroundColor: PColors.primary.withValues(alpha: 0.1),
    bottomSheetTheme: PBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: PElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: POutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: PTextFormFieldTheme.darkInputDecorationTheme,
  );
}

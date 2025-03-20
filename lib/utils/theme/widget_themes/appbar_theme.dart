import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class PAppBarTheme{
  PAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    iconTheme: IconThemeData(color: PColors.iconPrimary, size: PSizes.iconMd),
    actionsIconTheme: IconThemeData(color: PColors.iconPrimary, size: PSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: PColors.black, fontFamily: 'Cabin'),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: PColors.dark,
    surfaceTintColor: PColors.dark,
    iconTheme: IconThemeData(color: PColors.black, size: PSizes.iconMd),
    actionsIconTheme: IconThemeData(color: PColors.white, size: PSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: PColors.white, fontFamily: 'Cabin'),
  );
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pine/utils/constants/sizes.dart';

import '../../constants/colors.dart';

class PAppBarTheme{
  PAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: PColors.black, size: PSizes.iconMd),
    actionsIconTheme: IconThemeData(color: PColors.black, size: PSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: PColors.black),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: PColors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: PColors.white, size: PSizes.iconMd),
    actionsIconTheme: IconThemeData(color: PColors.white, size: PSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: PColors.white),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: PColors.dark,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
}
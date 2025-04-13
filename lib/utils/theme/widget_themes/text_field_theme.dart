import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class PTextFormFieldTheme{
  PTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
      errorMaxLines: 3,
      prefixIconColor: PColors.darkGrey,
      suffixIconColor: PColors.darkGrey,
      // constraints: const BoxConstraints.expand(height: 14.inputFieldHeight),
      labelStyle: const TextStyle(fontFamily: 'Cabin').copyWith(fontSize: PSizes.fontSizeMd, color: PColors.black),
      hintStyle: const TextStyle(fontFamily: 'Cabin').copyWith(fontSize: PSizes.fontSizeSm, color: PColors.black),
      errorStyle: const TextStyle(fontFamily: 'Cabin').copyWith(fontStyle: FontStyle.normal),
      floatingLabelStyle: const TextStyle(fontFamily: 'Cabin').copyWith(color: PColors.black.withValues(alpha: 0.8)),
      border: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: PColors.grey),
      ),
      enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: PColors.grey),
      ),
      focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: PColors.dark),
      ),
      errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: PColors.warning),
      ),
      focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 2, color: PColors.warning),
      )
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
      errorMaxLines: 2,
      prefixIconColor: PColors.darkGrey,
      suffixIconColor: PColors.darkGrey,
      // constraints: const BoxConstraints.expand(height: 14.inputFieldHeight),
      labelStyle: const TextStyle(fontFamily: 'Cabin').copyWith(fontSize: PSizes.fontSizeMd, color: PColors.white),
      hintStyle: const TextStyle(fontFamily: 'Cabin').copyWith(fontSize: PSizes.fontSizeSm, color: PColors.white),
      errorStyle: const TextStyle(fontFamily: 'Cabin').copyWith(fontStyle: FontStyle.normal),
      floatingLabelStyle: const TextStyle(fontFamily: 'Cabin').copyWith(color: PColors.white.withValues(alpha: 0.8)),
      border: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: PColors.darkGrey),
      ),
      enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: PColors.grey),
      ),
      focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: PColors.white),
      ),
      errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1, color: PColors.warning),
      ),
      focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 2, color: PColors.warning),
      )
  );
}
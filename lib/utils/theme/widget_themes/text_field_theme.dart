import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class PTextFormFieldTheme {
  PTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: PColors.darkGrey,
    suffixIconColor: PColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: PSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: PSizes.fontSizeMd, color: PColors.textPrimary, fontFamily: 'Cabin'),
    hintStyle: const TextStyle().copyWith(fontSize: PSizes.fontSizeSm, color: PColors.textSecondary, fontFamily: 'Cabin'),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal, fontFamily: 'Cabin'),
    floatingLabelStyle: const TextStyle().copyWith(color: PColors.textSecondary, fontFamily: 'Cabin'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: PColors.borderPrimary),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: PColors.borderPrimary),
    ),
    focusedBorder:const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: PColors.borderSecondary),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: PColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: PColors.error),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: PColors.darkGrey,
    suffixIconColor: PColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: PSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: PSizes.fontSizeMd, color: PColors.white, fontFamily: 'Cabin'),
    hintStyle: const TextStyle().copyWith(fontSize: PSizes.fontSizeSm, color: PColors.white, fontFamily: 'Cabin'),
    floatingLabelStyle: const TextStyle().copyWith(color: PColors.white.withValues(alpha: 0.8), fontFamily: 'Cabin'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: PColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: PColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: PColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: PColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(PSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: PColors.error),
    ),
  );
}

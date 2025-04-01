import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PLoaders {
  static hideSnackBar() =>
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  // static customToast({required message}) {
  //   ScaffoldMessenger.of(Get.context!).showSnackBar(
  //     SnackBar(
  //       elevation: 0,
  //       duration: const Duration(seconds: 1),
  //       backgroundColor: Colors.transparent,
  //       content: Container(
  //         padding: const EdgeInsets.all(12.0),
  //         margin: const EdgeInsets.symmetric(horizontal: 30),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(30),
  //           color: PHelperFunctions.isDarkMode(Get.context!)
  //               ? PColors.darkerGrey.withValues(alpha: 0.9)
  //               : PColors.grey.withValues(alpha: 0.9),
  //         ),
  //         child: Center(
  //             child: Text(message,
  //                 style: Theme.of(Get.context!).textTheme.labelLarge)),
  //       ),
  //     ),
  //   );
  // }

  static customToast({required message}) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style:
            const TextStyle(color: PColors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: PColors.warning,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 1000),
      animationDuration: const Duration(milliseconds: 500),
      borderRadius: 16,
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: PColors.white),
    );
  }

  static successOBar({required message}) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style:
            const TextStyle(color: PColors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: PColors.primary,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 1000),
      animationDuration: const Duration(milliseconds: 500),
      borderRadius: 16,
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.tick_circle, color: PColors.white),
    );
  }

  static successSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: PColors.white,
      backgroundColor: PColors.primary,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 1000),
      animationDuration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.tick_circle, color: PColors.white),
    );
  }

  static warningSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: PColors.white,
      backgroundColor: PColors.warning,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 1000),
      animationDuration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: PColors.white),
    );
  }

  static errorSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: PColors.white,
      backgroundColor: PColors.error,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 1000),
      animationDuration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: PColors.white),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../common/widgets/loaders/animation_loader.dart';

class PFullScreenLoader {
  static void openLoadingDiaLog(String text, String animation) {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => PopScope(
              canPop: false,
              child: Container(
                color: PHelperFunctions.isDarkMode(Get.context!)
                    ? PColors.dark
                    : PColors.white,
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 250),
                    PAnimationLoaderWidget(text: text, animation: animation),
                  ],
                ),
              ),
            ));
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}

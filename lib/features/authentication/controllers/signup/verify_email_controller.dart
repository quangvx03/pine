import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/success_screen/success_screen.dart';
import 'package:pine/data/repositories/authentication/authentication_repository.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/text_strings.dart';
import 'package:pine/utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      PLoaders.successSnackBar(
          title: 'Đã gửi email',
          message:
              'Vui lòng kiểm tra hộp thư đến của bạn và xác minh email của bạn.');
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra', message: e.toString());
    }
  }

  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(() => SuccessScreen(
              image: PImages.successfullyRegAnimation,
              title: PTexts.yourAccountCreatedTitle,
              subTitle: PTexts.yourAccountCreatedSubTitle,
              onPressed: () =>
                  AuthenticationRepository.instance.screenRedirect(),
            ));
      }
    });
  }

  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(() => SuccessScreen(
          image: PImages.successfullyRegAnimation,
          title: PTexts.yourAccountCreatedTitle,
          subTitle: PTexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect()));
    }
  }
}

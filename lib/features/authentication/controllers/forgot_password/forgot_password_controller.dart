import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/authentication/authentication_repository.dart';
import 'package:pine/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/helpers/network_manager.dart';
import 'package:pine/utils/popups/full_screen_loader.dart';
import 'package:pine/utils/popups/loaders.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async {
    try {
      PFullScreenLoader.openLoadingDiaLog(
          'Đang xử lý yêu cầu...', PImages.verify);

      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgotPasswordFormKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      // Remove Loader
      PFullScreenLoader.stopLoading();

      // Show Success Screen
      PLoaders.successSnackBar(
          title: 'Đã gửi email',
          message: 'Liên kết email được gửi để đặt lại mật khẩu của bạn'.tr);

      //Redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      PFullScreenLoader.openLoadingDiaLog(
          'Đang xử lý yêu cầu...', PImages.verify);

      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // Remove Loader
      PFullScreenLoader.stopLoading();

      // Show Success Screen
      PLoaders.successSnackBar(
          title: 'Đã gửi email',
          message: 'Liên kết email được gửi để đặt lại mật khẩu của bạn'.tr);
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra', message: e.toString());
    }
  }
}

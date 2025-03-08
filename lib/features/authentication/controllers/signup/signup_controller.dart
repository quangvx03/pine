import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/data/repositories/user_repository.dart';
import 'package:pine/features/authentication/screens/signup/verify_email.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/popups/full_screen_loader.dart';
import 'package:pine/utils/popups/loaders.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../personalization/models/user_model.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  final privacyPolicy = false.obs;
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void signup() async {
    try {
      // Start Loading
      PFullScreenLoader.openLoadingDiaLog('Đang xử lý...', PImages.verify);

      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // Remove Loader
        PFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        // Remove Loader
        PFullScreenLoader.stopLoading();
        return;
      }
      // Privacy Policy Check
      if (!privacyPolicy.value) {
        PLoaders.warningSnackBar(
          title: 'Chấp nhận chính sách bảo mật',
          message:
              'Để tạo tài khoản, bạn phải đọc và chấp nhận chính sách & thời hạn sử dụng quyền riêng tư.',
        );
        // Remove Loader
        PFullScreenLoader.stopLoading();
        return;
      }

      // Register user in the Firebase Authentication & Save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // Save Authenticated user data in the Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Remove Loader
      PFullScreenLoader.stopLoading();

      // Show Success Message
      PLoaders.successSnackBar(
          title: 'Chúc mừng',
          message:
              'Tài khoản của bạn đã được tạo! Xác minh email để tiếp tục.');

      // Move to verify Email Screen
      Get.to(() =>  VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      // Remove Loader
      PFullScreenLoader.stopLoading();

      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/features/personalization/controllers/user_controller.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/helpers/network_manager.dart';
import 'package:pine/utils/popups/full_screen_loader.dart';
import 'package:pine/utils/popups/loaders.dart';

class LoginController extends GetxController {
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  /// Email Password SignIn
  Future<void> emailAndPasswordSignIn() async {
    try {
      PFullScreenLoader.openLoadingDiaLog('Đang đăng nhập...', PImages.verify);

      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      // Save data if remember is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login user using Email & Password Auth
      final userCredentials = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Remove Loader
      PFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra', message: e.toString());
    }
  }

  /// Google SignIn
  Future<void> googleSignIn() async {
    try {
      PFullScreenLoader.openLoadingDiaLog('Đang đăng nhập...', PImages.verify);

      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }

      // Google auth
      final userCredentials =
          await AuthenticationRepository.instance.signInWithGoogle();

      //   Save User Record
      await userController.saveUserRecord(userCredentials);

      // Remove Loader
      PFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra', message: e.toString());
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pine_admin_panel/data/repositories/authentication_repository.dart';
import 'package:pine_admin_panel/data/repositories/user_repository.dart';
import 'package:pine_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:pine_admin_panel/features/personalization/models/user_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/text_strings.dart';
import 'package:pine_admin_panel/utils/helpers/network_manager.dart';
import 'package:pine_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

import '../../shop/screens/dashboard/dashboard.dart';
import '../../shop/screens/staff_dashboard/dashboard.dart';


class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();

  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME-EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME-PASSWORD') ?? '';
    super.onInit();
  }

  /// Handles email and password sign-in process
  Future<void> emailAndPasswordSignIn() async {
    try {
      PFullScreenLoader.openLoadingDialog('Đang đăng nhập...', PImages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }

      if (!loginFormKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME-EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME-PASSWORD', password.text.trim());
      }

      await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      final user = await UserController.instance.fetchStaffDetails();

      PFullScreenLoader.stopLoading();

      if (user.role == AppRole.admin) {
        localStorage.write('Role', 'admin');
        localStorage.write('activeItem', '/dashboard');
        Get.offAll(() => DashboardScreen());
      } else if (user.role == AppRole.staff) {
        localStorage.write('Role', 'staff');
        localStorage.write('activeItem', '/staff-dashboard');
        Get.offAll(() => StaffDashboardScreen());
      }


    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'ôi trời ơi', message: e.toString());
    }
  }

  /// Handles registration of admin user
  Future<void> registerAdmin() async {
    try {
      PFullScreenLoader.openLoadingDialog('Đăng ký tài khoản admin...', PImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.registerWithEmailAndPassword(PTexts.adminEmail, PTexts.adminPassword);

      final userRepository = Get.put(UserRepository());
      await userRepository.createUser(
        UserModel(
          id: AuthenticationRepository.instance.authUser!.uid,
          firstName: 'User',
          lastName: 'Admin',
          email: PTexts.adminEmail,
          role: AppRole.admin,
          createdAt: DateTime.now(),
        ),
      );

      PFullScreenLoader.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'ôi trời ơi', message: e.toString());
    }
  }
}
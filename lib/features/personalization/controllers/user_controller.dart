import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/data/repositories/user_repository.dart';
import 'package:pine/features/authentication/screens/login/login.dart';
import 'package:pine/features/personalization/screens/profile/widgets/re_auth_user_login_form.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/network_manager.dart';
import 'package:pine/utils/popups/full_screen_loader.dart';
import 'package:pine/utils/popups/loaders.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  /// Fetch user record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  /// Save user record from any registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      // Update Rx User and then check if user data is already stored. If not store new data
      await fetchUserRecord();

      // If no record already stored
      if (user.value.id.isEmpty) {
        if (userCredentials != null) {
          // Convert Name to First and Last Name
          final nameParts =
              UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final username = UserModel.generateUsername(
              userCredentials.user!.displayName ?? '');

          // Map Data
          final user = UserModel(
              id: userCredentials.user!.uid,
              firstName: nameParts[0],
              lastName:
                  nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
              username: username,
              email: userCredentials.user!.email ?? '',
              phoneNumber: userCredentials.user!.phoneNumber ?? '',
              profilePicture: userCredentials.user!.photoURL ?? '');

          //   Save user data
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      PLoaders.warningSnackBar(
          title: 'Dữ liệu chưa được lưu',
          message:
              'Có gì đó không ổn trong khi lưu thông tin của bạn. Bạn có thể lưu lại dữ liệu của mình trong hồ sơ của mình');
    }
  }

  /// Delete Account Warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(PSizes.md),
        title: 'Xoá tài khoản',
        middleText:
            'Bạn có chắc chắn muốn xóa tài khoản của mình vĩnh viễn không? Tất cả dữ liệu của bạn sẽ bị xóa vĩnh viễn.',
        confirm: ElevatedButton(
          onPressed: () async => deleteUserAccount(),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              side: const BorderSide(color: Colors.red)),
          child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: PSizes.lg),
              child: Text('Xoá')),
        ),
        cancel: OutlinedButton(
            child: const Text('Huỷ'),
            onPressed: () => Navigator.of(Get.overlayContext!).pop()));
  }

  /// Delete User Account
  void deleteUserAccount() async {
    try {
      PFullScreenLoader.openLoadingDiaLog('Đang xử lý...', PImages.verify);

      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        // Re verify auth email
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          PFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          PFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthUserLoginForm());
        }
      }
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.warningSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
    }
  }

  /// Re Auth
  Future<void> reAuthEmailAndPasswordUser() async {
    try {
      PFullScreenLoader.openLoadingDiaLog('Đang xử lý', PImages.verify);

      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthWithEmailAndPassword(
          verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      PFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.warningSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
    }
  }

  /// Upload Profile Image
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);
      if (image != null) {
        imageUploading.value = true;
        // Upload Image
        final imageUrl =
            await userRepository.uploadImage('Users/Images/Profile/', image);

        // Update User Image Record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();

        PLoaders.successSnackBar(
            title: 'Chúc mừng', message: 'Ảnh đại diện đã được tải lên!');
      }
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra', message: e.toString());
    } finally{
      imageUploading.value = false;
    }
  }
}

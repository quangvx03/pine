import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/features/personalization/screens/profile/profile.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/popups/full_screen_loader.dart';
import 'package:pine/utils/popups/loaders.dart';

class ChangePasswordController extends GetxController {
  static ChangePasswordController get instance => Get.find();

  // Form key
  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  // Text controllers
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  // Visibility
  RxBool hideCurrentPassword = true.obs;
  RxBool hideNewPassword = true.obs;
  RxBool hideConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Không cần khởi tạo giá trị cho mật khẩu
  }

  // Thay đổi mật khẩu
  Future<void> changePassword() async {
    try {
      if (!changePasswordFormKey.currentState!.validate()) {
        return;
      }

      // Hiển thị màn hình loading với hiệu ứng giống ProfileEditController
      PFullScreenLoader.openLoadingDiaLog(
          'Mật khẩu của bạn đang được cập nhật...', PImages.verify);

      // Xác thực người dùng với mật khẩu hiện tại
      final auth = AuthenticationRepository.instance;
      await auth.reAuthWithEmailAndPassword(
        auth.authUser.email!,
        currentPassword.text.trim(),
      );

      // Cập nhật mật khẩu
      await auth.authUser.updatePassword(newPassword.text.trim());

      // Thêm độ trễ để hiển thị loading rõ ràng hơn (giống với ProfileEditController)
      await Future.delayed(const Duration(milliseconds: 1500));

      // Đóng loading dialog
      PFullScreenLoader.stopLoading();

      // Hiển thị thông báo thành công với tiêu đề giống ProfileEditController
      PLoaders.successSnackBar(
        title: 'Chúc mừng',
        message: 'Mật khẩu của bạn đã được thay đổi thành công',
      );

      // Xóa form và quay lại tương tự ProfileEditController
      clearForm();
      Get.off(() =>
          const ProfileScreen()); // Sử dụng Get.off thay vì Get.back để tránh stack trùng lặp
    } catch (e) {
      // Đảm bảo đóng loading dialog nếu có lỗi
      PFullScreenLoader.stopLoading();

      // Hiển thị lỗi với định dạng giống ProfileEditController
      PLoaders.errorSnackBar(
        title: 'Cập nhật thất bại',
        message: e.toString(),
      );
    }
  }

  // Xóa dữ liệu form
  void clearForm() {
    currentPassword.clear();
    newPassword.clear();
    confirmPassword.clear();
  }

  @override
  void onClose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}

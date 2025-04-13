import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pine_admin_panel/data/repositories/user_repository.dart';
import 'package:pine_admin_panel/features/media/controllers/media_controller.dart';
import 'package:pine_admin_panel/features/media/models/image_model.dart';
import 'package:pine_admin_panel/features/personalization/models/user_model.dart';
import 'package:pine_admin_panel/utils/helpers/network_manager.dart';
import 'package:pine_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';
import '../../../data/repositories/authentication_repository.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final currentPasswordController = TextEditingController();

  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    final role = GetStorage().read('Role');
    if (role == 'admin') {
      fetchUserDetails();
    } else if (role == 'staff') {
      fetchStaffDetails();
    }
    super.onInit();
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      final fetchedUser = await userRepository.fetchAdminDetails();
      user.value = fetchedUser;
      loading.value = false;
      return fetchedUser;
    } catch (e) {
      loading.value = false;
      PLoaders.errorSnackBar(title: 'Đã xảy ra lỗi.', message: e.toString());
      return UserModel.empty();
    }
  }

  Future<UserModel> fetchStaffDetails() async {
    try {
      loading.value = true;
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null) throw 'Người dùng không tồn tại';

      final fetchedUser = await userRepository.fetchAllStaffDetails(userId);
      user.value = fetchedUser;
      loading.value = false;
      return fetchedUser;
    } catch (e) {
      loading.value = false;
      PLoaders.errorSnackBar(title: 'Đã xảy ra lỗi.', message: e.toString());
      return UserModel.empty();
    }
  }

  void updateProfilePicture() async {
    try {
      loading.value = true;
      final controller = Get.put(MediaController());
      final selectedImages = await controller.selectImagesFromMedia();

      if (selectedImages != null && selectedImages.isNotEmpty) {
        final selectedImage = selectedImages.first;
        await userRepository.updateSingleField({'ProfilePicture': selectedImage.url});
        user.value.profilePicture = selectedImage.url;
        user.refresh();
        PLoaders.successSnackBar(title: 'Thành công', message: 'Đã cập nhật ảnh đại diện');
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      PLoaders.errorSnackBar(title: 'Ôi không', message: e.toString());
    }
  }

  void updateAdminInformation() async {
    try {
      loading.value = true;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        PFullScreenLoader.stopLoading();
        return;
      }

      if (!formKey.currentState!.validate()) {
        loading.value = false;
        PFullScreenLoader.stopLoading();
        return;
      }

      // Cập nhật thông tin người dùng
      user.value.firstName = firstNameController.text.trim();
      user.value.lastName = lastNameController.text.trim();
      user.value.phoneNumber = phoneController.text.trim();

      await userRepository.updateUserDetails(user.value);

      // Nếu có nhập mật khẩu mới
      final newPassword = passwordController.text.trim();
      final currentPassword = currentPasswordController.text.trim();

      if (newPassword.isNotEmpty) {
        if (newPassword.length < 6) {
          loading.value = false;
          PLoaders.errorSnackBar(
              title: 'Lỗi', message: 'Mật khẩu phải có ít nhất 6 ký tự');
          return;
        }

        // Re-authenticate trước khi đổi mật khẩu
        final email = user.value.email;
        final isReAuthenticated = await AuthenticationRepository.instance
            .reAuthenticateUser(email, currentPassword);

        if (!isReAuthenticated) {
          loading.value = false;
          PLoaders.errorSnackBar(
            title: 'Sai mật khẩu hiện tại',
            message: 'Vui lòng nhập đúng mật khẩu hiện tại để tiếp tục',
          );
          return;
        }

        // Đổi mật khẩu
        await AuthenticationRepository.instance.updatePassword(newPassword);
      }

      user.refresh();
      loading.value = false;

      PLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Hồ sơ tài khoản đã được cập nhật',
      );
    } catch (e) {
      loading.value = false;
      PLoaders.errorSnackBar(title: 'Ôi không', message: e.toString());
    }
  }

}

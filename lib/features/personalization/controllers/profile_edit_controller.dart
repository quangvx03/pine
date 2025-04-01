import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine/features/personalization/controllers/user_controller.dart';
import 'package:pine/features/personalization/screens/profile/profile.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/popups/full_screen_loader.dart';
import 'package:pine/utils/popups/loaders.dart';

class ProfileEditController extends GetxController {
  static ProfileEditController get instance => Get.find();

  final userController = UserController.instance;
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();

  // Form Controllers
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final gender = ''.obs;
  final dateOfBirth = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initializeFields();
  }

  void initializeFields() {
    final user = userController.user.value;
    firstName.text = user.firstName;
    lastName.text = user.lastName;
    email.text = user.email;
    phoneNumber.text = user.phoneNumber;
    gender.value = user.gender.isNotEmpty ? user.gender : 'Nam';
    dateOfBirth.value = user.dateOfBirth.isNotEmpty
        ? user.dateOfBirth
        : DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dateOfBirth.value = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> updateUserProfile() async {
    try {
      if (!profileFormKey.currentState!.validate()) {
        return;
      }

      // Hiển thị màn hình loading
      PFullScreenLoader.openLoadingDiaLog(
          'Thông tin của bạn đang được cập nhật...', PImages.verify);

      // Cập nhật thông tin người dùng
      Map<String, dynamic> updatedData = {
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim(),
        'PhoneNumber': phoneNumber.text.trim(),
        'Gender': gender.value,
        'DateOfBirth': dateOfBirth.value,
      };

      await userController.userRepository.updateSingleField(updatedData);

      // Cập nhật thông tin locally
      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();
      userController.user.value.phoneNumber = phoneNumber.text.trim();
      userController.user.value.gender = gender.value;
      userController.user.value.dateOfBirth = dateOfBirth.value;

      userController.user.refresh();

      await Future.delayed(const Duration(milliseconds: 1500));

      // Đóng loading dialog
      PFullScreenLoader.stopLoading();

      // Hiển thị thông báo thành công
      PLoaders.successSnackBar(
        title: 'Chúc mừng',
        message: 'Thông tin cá nhân đã được cập nhật',
      );

      Get.off(() => const ProfileScreen());
    } catch (e) {
      // Đảm bảo đóng loading dialog nếu có lỗi
      PFullScreenLoader.stopLoading();

      PLoaders.errorSnackBar(
        title: 'Cập nhật thất bại',
        message: e.toString(),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/utils/helpers/network_manager.dart';
import 'package:pine_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

import '../../../../data/repositories/authentication_repository.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';
import '../../../personalization/models/address_model.dart';
import '../../../personalization/models/user_model.dart';
import 'customer_controller.dart';

class CreateStaffController extends GetxController {
  static CreateStaffController get instance => Get.find();

  final UserRepository userRepository = Get.put(UserRepository());

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final profilePicture = ''.obs;
  final password = TextEditingController();
  final hidePassword = true.obs;
  final roleController = Rx<AppRole>(AppRole.staff);

  final nameController = TextEditingController();
  final phoneNumberAddressController = TextEditingController();
  final streetController = TextEditingController();
  final wardController = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();

  final loading = false.obs;
  final formKey = GlobalKey<FormState>();

  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      profilePicture.value = selectedImage.url;
    }
  }

  Future<void> createStaff() async {
    try {
      PFullScreenLoader.popUpCircular();

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        PLoaders.errorSnackBar(title: 'Mất kết nối', message: 'Không có kết nối mạng');
        return;
      }

      if (!formKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
          emailController.text.trim(), password.text.trim());

      final uid = userCredential.user?.uid;

      final newAddress = AddressModel(
        id: '',
        name: nameController.text.trim(),
        phoneNumber: phoneNumberAddressController.text.trim(),
        street: streetController.text.trim(),
        ward: wardController.text.trim(),
        city: cityController.text.trim(),
        province: provinceController.text.trim(),
      );

      final newStaff = UserModel(
        id: uid,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
        profilePicture: profilePicture.value,
        role: roleController.value,
        createdAt: DateTime.now(),
        addresses: [newAddress],
      );

      await UserRepository.instance.createUser(newStaff);

      CustomerController.instance.fetchItems();

      resetFields();
      PFullScreenLoader.stopLoading();
      PLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Đã thêm nhân viên thành công: ${newStaff.fullName}',
      );
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Ôi không', message: e.toString());
    }
  }

  void resetFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    profilePicture.value = '';
    password.clear();
    roleController.value = AppRole.staff;

    nameController.clear();
    phoneNumberAddressController.clear();
    streetController.clear();
    wardController.clear();
    cityController.clear();
    provinceController.clear();
  }
}

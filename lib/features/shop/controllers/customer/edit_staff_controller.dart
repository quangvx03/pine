import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';
import '../../../personalization/models/user_model.dart';
import '../../../personalization/models/address_model.dart';
import 'customer_controller.dart';

class EditStaffController extends GetxController {
  static EditStaffController get instance => Get.find();

  final loading = false.obs;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final profilePicture = ''.obs;
  final role = Rx<AppRole>(AppRole.staff);

  final nameController = TextEditingController();
  final phoneNumberAddressController = TextEditingController();
  final streetController = TextEditingController();
  final wardController = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void init(UserModel user) {
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    emailController.text = user.email;
    phoneNumberController.text = user.phoneNumber;
    profilePicture.value = user.profilePicture;
    role.value = user.role;

    if (user.addresses!.isNotEmpty) {
      final address = user.addresses!.first;
      nameController.text = address.name;
      phoneNumberAddressController.text = address.phoneNumber;
      streetController.text = address.street;
      wardController.text = address.ward;
      cityController.text = address.city;
      provinceController.text = address.province;
    }
  }

  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      profilePicture.value = selectedImage.url;
    }
  }

  Future<void> updateStaff(UserModel user) async {
    try {
      PFullScreenLoader.popUpCircular();
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }
      if (!formKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      user.firstName = firstNameController.text.trim();
      user.lastName = lastNameController.text.trim();
      user.email = emailController.text.trim();
      user.phoneNumber = phoneNumberController.text.trim();
      user.profilePicture = profilePicture.value;
      user.role = role.value;
      user.updatedAt = DateTime.now();

      final updatedAddress = AddressModel(
        id: user.addresses!.isNotEmpty ? user.addresses!.first.id : '',
        name: nameController.text.trim(),
        phoneNumber: phoneNumberAddressController.text.trim(),
        street: streetController.text.trim(),
        ward: wardController.text.trim(),
        city: cityController.text.trim(),
        province: provinceController.text.trim(),
      );
      user.addresses = [updatedAddress];

      await UserRepository.instance.updateUserDetails(user);

        CustomerController.instance.updateItemFromLists(user);

      resetFields();

      PFullScreenLoader.stopLoading();
      PLoaders.successSnackBar(title: 'Thành công', message: 'Thông tin nhân viên đã được cập nhật!');
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }

  void resetFields() {
    loading(false);
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    profilePicture.value = '';
    role.value = AppRole.staff;

    nameController.clear();
    phoneNumberAddressController.clear();
    streetController.clear();
    wardController.clear();
    cityController.clear();
    provinceController.clear();
  }
}

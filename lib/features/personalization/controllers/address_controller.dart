import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/data/repositories/address_repository.dart';
import 'package:pine/features/personalization/models/address_model.dart';
import 'package:pine/features/personalization/screens/address/add_edit_address.dart';
import 'package:pine/features/personalization/screens/address/widgets/single_address.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/cloud_helper_functions.dart';
import 'package:pine/utils/helpers/network_manager.dart';
import 'package:pine/utils/popups/full_screen_loader.dart';
import 'package:pine/utils/popups/loaders.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final ward = TextEditingController();
  final city = TextEditingController();
  final province = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());

  // Thêm các biến này
  RxBool isProcessing = false.obs;
  RxString processingAddressId = ''.obs;

  /// Fetch all user specific addresses
  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      final addresses = await addressRepository.fetchUserAddresses();
      selectedAddress.value = addresses.firstWhere(
          (element) => element.selectedAddress,
          orElse: () => AddressModel.empty());

      addresses.sort((a, b) {
        if (a.selectedAddress && !b.selectedAddress) return -1;

        if (!a.selectedAddress && b.selectedAddress) return 1;

        if (a.dateTime == null && b.dateTime == null) return 0;
        if (a.dateTime == null) return 1;
        if (b.dateTime == null) return -1;

        return b.dateTime!.compareTo(a.dateTime!);
      });

      return addresses;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Không có địa chỉ!', message: e.toString());
      return [];
    }
  }

  Future selectAddress(AddressModel newSelectedAddress) async {
    try {
      if (isProcessing.value) return;
      if (selectedAddress.value.id == newSelectedAddress.id) return;

      isProcessing.value = true;
      processingAddressId.value = newSelectedAddress.id;

      final oldSelectedAddress = selectedAddress.value;

      if (selectedAddress.value.id.isNotEmpty) {
        selectedAddress.value.selectedAddress = false;
      }
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }

      try {
        // Bỏ chọn địa chỉ cũ
        if (oldSelectedAddress.id.isNotEmpty) {
          await addressRepository.updateSelectedField(
              oldSelectedAddress.id, false);
        }

        // Chọn địa chỉ mới
        await addressRepository.updateSelectedField(
            newSelectedAddress.id, true);

        // Hiển thị thông báo thành công
        PLoaders.successOBar(
          message: 'Địa chỉ giao hàng đã được thay đổi!',
        );
      } catch (e) {
        // Nếu API thất bại, khôi phục lại UI
        if (oldSelectedAddress.id.isNotEmpty) {
          oldSelectedAddress.selectedAddress = true;
        }
        newSelectedAddress.selectedAddress = false;
        selectedAddress.value = oldSelectedAddress;

        // Hiển thị thông báo lỗi
        PLoaders.errorSnackBar(title: 'Lỗi khi chọn!', message: e.toString());
      }

      // Kết thúc xử lý
      isProcessing.value = false;
      processingAddressId.value = '';
    } catch (e) {
      // Kết thúc xử lý nếu có lỗi khác
      isProcessing.value = false;
      processingAddressId.value = '';
      PLoaders.errorSnackBar(title: 'Lỗi khi chọn!', message: e.toString());
    }
  }

  /// Add new address
  Future addNewAddresses() async {
    try {
      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!addressFormKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      // Save Address data
      final address = AddressModel(
          id: '',
          name: name.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          street: street.text.trim(),
          ward: ward.text.trim(),
          city: city.text.trim(),
          province: province.text.trim(),
          selectedAddress: false);
      final id = await addressRepository.addAddress(address);

      // Update selected address status
      address.id = id;

      // Remove Loader
      PFullScreenLoader.stopLoading();

      // Show success message
      PLoaders.successSnackBar(
          title: 'Hoàn tất!', message: 'Địa chỉ mới đã được thêm thành công');

      // Refresh Addresses data
      refreshData.toggle();

      // Reset fields
      resetFormFields();
    } catch (e) {
      // Remove Loader
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(
        title: 'Lỗi!',
        message: 'Không tìm thấy địa chỉ. Vui lòng thử lại sau.',
      );
    }
  }

  Future<void> deleteAddress(AddressModel address) async {
    try {
      final shouldDelete = await Get.defaultDialog<bool>(
        contentPadding: const EdgeInsets.all(PSizes.md),
        title: 'Xoá địa chỉ',
        middleText: 'Bạn có chắc chắn muốn xóa địa chỉ này không?',
        confirm: ElevatedButton(
          onPressed: () {
            Get.back(result: true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: PColors.error,
            side: const BorderSide(color: PColors.error),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: PSizes.lg),
            child: Text('Xóa'),
          ),
        ),
        cancel: OutlinedButton(
          child: const Text('Hủy'),
          onPressed: () => Get.back(result: false),
        ),
      );

      if (shouldDelete != true) return;

      await addressRepository.deleteAddress(address.id);
      refreshData.toggle();

      PLoaders.successOBar(
        message: 'Địa chỉ đã được xóa khỏi danh sách!',
      );
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(
        title: 'Lỗi khi xóa!',
        message: 'Đã có lỗi xảy ra khi xóa địa chỉ, vui lòng thử lại sau',
      );
    }
  }

  /// Edit address
  Future<void> editAddress(AddressModel address) async {
    name.text = address.name;
    phoneNumber.text = address.phoneNumber;
    street.text = address.street;
    ward.text = address.ward;
    city.text = address.city;
    province.text = address.province;

    await Get.to(
        () => AddEditAddressScreen(isEditMode: true, addressToEdit: address));
  }

  /// Update existing address
  Future<void> updateAddress(AddressModel originalAddress) async {
    try {
      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PLoaders.warningSnackBar(
            title: 'Không có kết nối!',
            message: 'Vui lòng kiểm tra kết nối internet và thử lại');
        return;
      }

      // Form Validation
      if (!addressFormKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      // Create updated address model
      final updatedAddress = AddressModel(
        id: originalAddress.id,
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        ward: ward.text.trim(),
        city: city.text.trim(),
        province: province.text.trim(),
        selectedAddress: originalAddress.selectedAddress,
      );

      // Update in repository
      await addressRepository.updateAddress(updatedAddress);

      // If this is the selected address, update the selected address
      if (originalAddress.selectedAddress) {
        selectedAddress.value = updatedAddress;
      }

      // Remove Loader
      PFullScreenLoader.stopLoading();

      // Show success message
      PLoaders.successOBar(
        message: 'Thông tin địa chỉ đã được cập nhật!',
      );

      refreshData.toggle();

      // Reset fields
      resetFormFields();
    } catch (e) {
      // Remove Loader
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(
        title: 'Lỗi khi cập nhật!',
        message: 'Có lỗi xảy ra khi cập nhật địa chỉ, vui lòng thử lại sau',
      );
    }
  }

  Future<dynamic> selectNewAddressPopup(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: const EdgeInsets.all(PSizes.lg),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PSectionHeading(
                      title: 'Chọn địa chỉ', showActionButton: false),
                  const SizedBox(height: PSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(() {
                      refreshData.value;

                      return FutureBuilder(
                          future: getAllUserAddresses(),
                          builder: (_, snapshot) {
                            final response =
                                PCloudHelperFunctions.checkMultiRecordState(
                                    snapshot: snapshot);
                            if (response != null) return response;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (_, index) => PSingleAddress(
                                address: snapshot.data![index],
                                onTap: () {
                                  selectAddress(snapshot.data![index]);
                                },
                              ),
                            );
                          });
                    }),
                  ),
                  const SizedBox(height: PSizes.defaultSpace),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () =>
                            Get.to(() => const AddEditAddressScreen()),
                        child: const Text('Thêm địa chỉ mới')),
                  )
                ],
              ),
            ));
  }

  /// Reset form fields
  void resetFormFields() {
    name.clear();
    phoneNumber.clear();
    street.clear();
    ward.clear();
    city.clear();
    province.clear();
    addressFormKey.currentState?.reset();
  }
}

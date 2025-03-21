import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/loaders/circular_loader.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/data/repositories/address_repository.dart';
import 'package:pine/features/personalization/models/address_model.dart';
import 'package:pine/features/personalization/screens/address/add_new_address.dart';
import 'package:pine/features/personalization/screens/address/widgets/single_address.dart';
import 'package:pine/utils/constants/image_strings.dart';
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

  /// Fetch all user specific addresses
  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      final addresses = await addressRepository.fetchUserAddresses();
      selectedAddress.value = addresses.firstWhere(
          (element) => element.selectedAddress,
          orElse: () => AddressModel.empty());
      return addresses;
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Không có địa chỉ!', message: e.toString());
      return [];
    }
  }

  Future selectAddress(AddressModel newSelectedAddress) async {
    try {
      Get.defaultDialog(
        title: '',
        onWillPop: () async {
          return false;
        },
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const PCircularLoader(),
      );

      // Clear the "selected" field
      if (selectedAddress.value.id.isNotEmpty) {
        await addressRepository.updateSelectedField(
            selectedAddress.value.id, false);
      }

      // Assign selected address
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      // Set the "selected" field to true for the newly selected address
      await addressRepository.updateSelectedField(
          selectedAddress.value.id, true);

      Get.back();
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Lỗi khi chọn!', message: e.toString());
    }
  }

  /// Add new address
  Future addNewAddresses() async {
    try {
      PFullScreenLoader.openLoadingDiaLog(
          'Đang lưu địa chỉ...', PImages.verify);

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
          selectedAddress: true);
      final id = await addressRepository.addAddress(address);

      // Update selected address status
      address.id = id;
      await selectAddress(address);

      // Remove Loader
      PFullScreenLoader.stopLoading();

      // Show success message
      PLoaders.successSnackBar(
          title: 'Chúc mừng!',
          message: 'Địa chỉ của bạn đã được lưu thành công.');

      // Refresh Addresses data
      refreshData.toggle();

      // Reset fields
      resetFormFields();

      // Redirect
      Navigator.of(Get.context!).pop();
    } catch (e) {
      // Remove Loader
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(
          title: 'Không tìm thấy địa chỉ!', message: e.toString());
    }
  }

  Future<dynamic> selectNewAddressPopup(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Cho phép cuộn toàn bộ bottom sheet
        builder: (_) => Container(
              padding: const EdgeInsets.all(PSizes.lg),
              // Giới hạn chiều cao tối đa của bottom sheet
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Chỉ chiếm không gian cần thiết
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PSectionHeading(
                      title: 'Chọn địa chỉ', showActionButton: false),
                  const SizedBox(height: PSizes.spaceBtwItems),

                  // Đặt ListView trong Expanded để có thể cuộn
                  Expanded(
                    child: FutureBuilder(
                        future: getAllUserAddresses(),
                        builder: (_, snapshot) {
                          final response =
                              PCloudHelperFunctions.checkMultiRecordState(
                                  snapshot: snapshot);
                          if (response != null) return response;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const AlwaysScrollableScrollPhysics(), // Luôn cho phép cuộn
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => PSingleAddress(
                              address: snapshot.data![index],
                              onTap: () async {
                                await selectAddress(snapshot.data![index]);
                                Get.back();
                              },
                            ),
                          );
                        }),
                  ),

                  const SizedBox(height: PSizes.defaultSpace),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () =>
                            Get.to(() => const AddNewAddressScreen()),
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

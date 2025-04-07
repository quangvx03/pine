import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/loaders/animation_loader.dart';
import 'package:pine/features/personalization/controllers/address_controller.dart';
import 'package:pine/features/personalization/screens/address/add_edit_address.dart';
import 'package:pine/features/personalization/screens/address/widgets/single_address.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    final dark = PHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        title: Text(
          'Địa chỉ',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Obx(
        () => FutureBuilder(
          // Use key to trigger refresh data
          key: Key(controller.refreshData.value.toString()),
          future: controller.getAllUserAddresses(),
          builder: (context, snapshot) {
            // Xử lý loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Xử lý lỗi
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Iconsax.warning_2, size: 50, color: Colors.red),
                    const SizedBox(height: PSizes.spaceBtwItems),
                    Text(
                      'Có lỗi xảy ra khi tải địa chỉ',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: PSizes.spaceBtwItems),
                    ElevatedButton(
                      onPressed: () => controller.refreshData.toggle(),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            // Xử lý khi không có địa chỉ
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox(
                height: PHelperFunctions.screenHeight() * 0.7,
                child: Center(
                  child: PAnimationLoaderWidget(
                    text: 'Bạn chưa có địa chỉ nào',
                    animation: PImages.empty,
                    showAction: true,
                    actionText: 'Thêm địa chỉ mới',
                    onActionPressed: () {
                      controller.resetFormFields();
                      Get.to(() => const AddEditAddressScreen());
                    },
                  ),
                ),
              );
            }

            // Hiển thị danh sách địa chỉ
            final addresses = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(PSizes.defaultSpace),
              itemCount: addresses.length,
              itemBuilder: (_, index) => PSingleAddress(
                address: addresses[index],
                onTap: () => controller.selectAddress(addresses[index]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PColors.primary,
        onPressed: () {
          controller.resetFormFields();
          Get.to(() => const AddEditAddressScreen());
        },
        child: Icon(Iconsax.add, color: PColors.white),
      ),
    );
  }
}

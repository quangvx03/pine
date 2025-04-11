import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/personalization/controllers/address_controller.dart';
import 'package:pine/features/personalization/models/address_model.dart';
import 'package:pine/features/personalization/screens/address/add_edit_address.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PBillingAddressSection extends StatelessWidget {
  const PBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;
    final dark = PHelperFunctions.isDarkMode(context);

    // Đảm bảo chắc chắn rằng địa chỉ được tải khi widget được xây dựng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addressController.getAllUserAddresses();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PSectionHeading(
            title: 'Địa chỉ nhận hàng',
            buttonTitle: 'Thay đổi',
            onPressed: () => addressController.selectNewAddressPopup(context)),
        const SizedBox(height: PSizes.spaceBtwItems),

        // Sử dụng Obx để phản ứng khi địa chỉ thay đổi
        Obx(() {
          // Lấy địa chỉ đã chọn
          final selectedAddress = addressController.selectedAddress.value;

          // Kiểm tra nếu có địa chỉ đã chọn (bao gồm cả địa chỉ mặc định)
          return selectedAddress.id.isNotEmpty
              ? _buildSelectedAddress(context, selectedAddress, dark)
              : _buildAddAddressButton(context, dark);
        }),
      ],
    );
  }

  // Widget hiển thị địa chỉ đã chọn
  Widget _buildSelectedAddress(
      BuildContext context, AddressModel address, bool dark) {
    final textColor = dark ? PColors.white : PColors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hàng 1: Tên người nhận
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon người dùng với decoration
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: PColors.darkerGrey.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.user,
                size: 16,
                color: PColors.darkerGrey,
              ),
            ),
            const SizedBox(width: PSizes.sm),
            Expanded(
              child: Text(
                address.name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: textColor,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: PSizes.spaceBtwItems),

        // Hàng 2: Số điện thoại
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon điện thoại với decoration
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: PColors.darkerGrey.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.call,
                size: 16,
                color: dark ? PColors.light : PColors.darkerGrey,
              ),
            ),
            const SizedBox(width: PSizes.sm),
            Text(
              address.phoneNumber,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: textColor,
                  ),
            ),
          ],
        ),

        const SizedBox(height: PSizes.sm),

        // Hàng 3: Chi tiết địa chỉ
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon địa điểm với decoration và padding top để căn chỉnh
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: PColors.darkerGrey.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.location,
                  size: 16,
                  color: dark ? PColors.light : PColors.darkerGrey,
                ),
              ),
            ),
            const SizedBox(width: PSizes.sm),
            Expanded(
              child: Text(
                '${address.street}, ${address.ward}, ${address.city}, ${address.province}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: textColor,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget hiển thị nút thêm địa chỉ khi chưa có địa chỉ nào
  Widget _buildAddAddressButton(BuildContext context, bool dark) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () => Get.to(() => const AddEditAddressScreen()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon thêm với decoration
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: PColors.primary.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.add,
                size: 16,
                color: PColors.primary,
              ),
            ),
            const SizedBox(width: PSizes.spaceBtwItems),
            Text(
              'Thêm địa chỉ giao hàng',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: PColors.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

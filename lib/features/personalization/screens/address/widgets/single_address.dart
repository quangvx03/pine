import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/personalization/controllers/address_controller.dart';
import 'package:pine/features/personalization/models/address_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';

class PSingleAddress extends StatelessWidget {
  const PSingleAddress({
    super.key,
    required this.address,
    required this.onTap,
  });

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final textColor = dark ? Colors.white70 : Colors.grey.shade700;

    return Obx(() {
      // Kiểm tra xem địa chỉ này có đang được xử lý không
      final isThisAddressProcessing = controller.isProcessing.value &&
          controller.processingAddressId.value == address.id;

      return Container(
        margin: const EdgeInsets.only(bottom: PSizes.md),
        decoration: BoxDecoration(
          color: dark ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(PSizes.md),
          border: Border.all(
            color: address.selectedAddress
                ? PColors.primary
                : Colors.grey.shade300,
            width: address.selectedAddress ? 2 : 1,
          ),
          boxShadow: [
            if (!dark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name, status, and action buttons
            Container(
              decoration: BoxDecoration(
                color: address.selectedAddress
                    ? PColors.primary.withValues(alpha: 0.1)
                    : dark
                        ? Colors.grey.shade700.withValues(alpha: 0.3)
                        : Colors.grey.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(PSizes.md - 1),
                  topRight: Radius.circular(PSizes.md - 1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Name section with select behavior
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.isProcessing.value ? null : onTap,
                      behavior: HitTestBehavior.translucent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: PSizes.md, vertical: PSizes.sm),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: address.selectedAddress
                                    ? PColors.primary
                                    : dark
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                address.selectedAddress
                                    ? Iconsax.tick_circle
                                    : Iconsax.user,
                                size: 16,
                                color: address.selectedAddress
                                    ? Colors.white
                                    : dark
                                        ? Colors.white70
                                        : Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(width: PSizes.sm),

                            // Phần tên và trạng thái
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Tên địa chỉ
                                  Text(
                                    address.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: address.selectedAddress
                                              ? PColors.primary
                                              : dark
                                                  ? PColors.light
                                                  : PColors.dark,
                                        ),
                                    maxLines: 2, // Tối đa 2 dòng
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  // Badge "Mặc định" hoặc "Nhấn để chọn làm mặc định"
                                  if (address.selectedAddress)
                                    Text(
                                      'Mặc định',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                            color: PColors.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Phần chứa các nút hành động và loading indicator
                  Stack(
                    alignment: Alignment.center, // Căn giữa loading indicator
                    children: [
                      // Nút hành động (edit/delete)
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Nút chỉnh sửa
                            _buildActionButton(
                              onTap: controller.isProcessing.value
                                  ? null
                                  : () => controller.editAddress(address),
                              icon: Iconsax.edit,
                              color: address.selectedAddress
                                  ? PColors.primary
                                  : dark
                                      ? PColors.light
                                      : PColors.darkerGrey,
                            ),

                            // Nút xóa
                            if (!address.selectedAddress)
                              _buildActionButton(
                                onTap: controller.isProcessing.value
                                    ? null
                                    : () => controller.deleteAddress(address),
                                icon: Iconsax.trash,
                                color: PColors.error,
                              ),
                          ],
                        ),
                      ),

                      // Loading indicator (hiển thị khi đang xử lý)
                      if (isThisAddressProcessing)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: dark ? Colors.grey.shade700 : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                PColors.primary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Address content with select behavior
            GestureDetector(
              onTap: controller.isProcessing.value ? null : onTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(PSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phone number
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: address.selectedAddress
                                ? PColors.primary.withValues(alpha: 0.1)
                                : dark
                                    ? PColors.darkerGrey
                                    : PColors.light,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Iconsax.call,
                            size: 16,
                            color: address.selectedAddress
                                ? PColors.primary
                                : textColor,
                          ),
                        ),
                        const SizedBox(width: PSizes.sm),
                        Text(
                          address.phoneNumber,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color:
                                    dark ? PColors.light : PColors.darkerGrey,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: PSizes.sm),

                    // Address details
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: address.selectedAddress
                                  ? PColors.primary.withValues(alpha: 0.1)
                                  : dark
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Iconsax.location,
                              size: 16,
                              color: address.selectedAddress
                                  ? PColors.primary
                                  : textColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: PSizes.sm),
                        Expanded(
                          child: Text(
                            '${address.street}, ${address.ward}, ${address.city}, ${address.province}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color:
                                      dark ? PColors.light : PColors.darkerGrey,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActionButton({
    VoidCallback? onTap,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 50,
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(PSizes.xs),
        ),
        child: Icon(
          icon,
          size: 24,
          color: onTap == null ? Colors.grey : color,
        ),
      ),
    );
  }
}

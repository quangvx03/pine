import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/features/shop/controllers/product/coupon_controller.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PCouponCode extends StatelessWidget {
  const PCouponCode({super.key});

  @override
  Widget build(BuildContext context) {
    final couponController = Get.find<CouponController>();
    final cartController = CartController.instance;
    final dark = PHelperFunctions.isDarkMode(context);

    return Obx(() {
      final selectedCoupon = couponController.selectedCoupon.value;
      final hasSelectedCoupon = selectedCoupon.id.isNotEmpty;
      final selectedItemsTotal = cartController.selectedItemsPrice.value;

      // Xác định icon dựa vào loại mã giảm giá
      final IconData couponIcon = hasSelectedCoupon
          ? (selectedCoupon.type == 'Cố định'
              ? Iconsax.money
              : Iconsax.percentage_square)
          : Iconsax.discount_shape;

      return GestureDetector(
        onTap: () =>
            couponController.showCouponSelectionModal(selectedItemsTotal),
        child: PRoundedContainer(
          showBorder: true,
          padding: const EdgeInsets.all(PSizes.md),
          backgroundColor: dark ? PColors.dark : PColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PSectionHeading(
                title: 'Mã giảm giá',
                showActionButton: false,
              ),

              const SizedBox(height: PSizes.spaceBtwItems),

              // Phần hiển thị mã giảm giá
              Row(
                children: [
                  // Icon với container tròn
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: hasSelectedCoupon
                          ? PColors.primary.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      couponIcon,
                      color: hasSelectedCoupon ? PColors.primary : Colors.grey,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: PSizes.md),

                  // Text
                  Expanded(
                    child: hasSelectedCoupon
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedCoupon.couponCode,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .apply(
                                      color: PColors.primary,
                                      fontWeightDelta: 1,
                                    ),
                              ),
                              const SizedBox(height: PSizes.xs / 2),
                              Text(
                                selectedCoupon.type == 'Cố định'
                                    ? 'Giảm ${PHelperFunctions.formatCurrency(selectedCoupon.discountAmount)}'
                                    : 'Giảm ${selectedCoupon.discountAmount.toStringAsFixed(0)}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .apply(
                                      color: PColors.primary,
                                    ),
                              ),
                            ],
                          )
                        : Text(
                            'Nhấn để chọn mã giảm giá',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                  ),

                  // Action button - Hiển thị nút xóa nếu đã chọn, nút mũi tên nếu chưa chọn
                  hasSelectedCoupon
                      ? GestureDetector(
                          onTap: () => couponController.clearSelectedCoupon(),
                          child: const Icon(
                            Iconsax.close_circle,
                            color: Colors.grey,
                            size: 18,
                          ),
                        )
                      : const Icon(
                          Iconsax.arrow_right_3,
                          color: Colors.grey,
                          size: 18,
                        ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

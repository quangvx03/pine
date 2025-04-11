import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/product/coupon_controller.dart';
import 'package:pine/features/shop/models/coupon_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class CouponSelectionModal extends StatelessWidget {
  const CouponSelectionModal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CouponController.instance;

    return Container(
      padding: const EdgeInsets.all(PSizes.lg),
      constraints: BoxConstraints(
        maxHeight: PHelperFunctions.screenHeight() * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề giống như địa chỉ
          const PSectionHeading(
              title: 'Chọn mã giảm giá', showActionButton: false),
          const SizedBox(height: PSizes.spaceBtwItems),

          // Danh sách mã giảm giá
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.availableCoupons.isEmpty) {
                return _buildEmptyCouponView(context);
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.availableCoupons.length,
                itemBuilder: (context, index) {
                  final coupon = controller.availableCoupons[index];
                  final isValid = coupon.minimumPurchaseAmount <=
                      controller.orderAmount.value;
                  final isSelected =
                      controller.selectedCoupon.value.id == coupon.id;

                  return CouponTile(
                    coupon: coupon,
                    isValid: isValid,
                    isSelected: isSelected,
                    onTap:
                        isValid ? () => controller.selectCoupon(coupon) : null,
                  );
                },
              );
            }),
          ),

          // Nút "Không áp dụng mã giảm giá"
          const SizedBox(height: PSizes.defaultSpace),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: PColors.primary, // màu chữ
              ),
              onPressed: () {
                controller.clearSelectedCoupon();
                Get.back();
              },
              child: const Text('Không áp dụng mã giảm giá'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCouponView(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.discount_shape,
              size: 40,
              color: dark ? PColors.light : PColors.darkerGrey,
            ),
            const SizedBox(height: PSizes.md),
            Text(
              'Không có mã giảm giá nào khả dụng',
              style: Get.textTheme.bodyLarge!.copyWith(
                color: dark ? PColors.light : PColors.darkerGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget hiển thị một mã giảm giá
class CouponTile extends StatelessWidget {
  final CouponModel coupon;
  final bool isValid;
  final bool isSelected;
  final VoidCallback? onTap;

  const CouponTile({
    super.key,
    required this.coupon,
    required this.isValid,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    final isCouponFixed = coupon.type == 'Cố định';
    final discountText = isCouponFixed
        ? PHelperFunctions.formatCurrency(coupon.discountAmount)
        : '${coupon.discountAmount.toStringAsFixed(0)}%';

    final Color textColor =
        isValid ? (dark ? PColors.light : PColors.dark) : Colors.grey;

    final Color primaryColor = isValid ? PColors.primary : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: PRoundedContainer(
        padding: const EdgeInsets.all(PSizes.md),
        margin: const EdgeInsets.only(bottom: PSizes.sm),
        backgroundColor: isSelected
            ? PColors.primary.withValues(alpha: 0.1)
            : dark
                ? PColors.darkerGrey
                : PColors.softGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hàng đầu tiên: Icon, mã giảm giá và giá trị giảm giá
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon dựa vào loại giảm giá
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(PSizes.sm),
                  child: Icon(
                    isCouponFixed ? Iconsax.money : Iconsax.percentage_square,
                    color: primaryColor,
                    size: 20, // Icon nhỏ hơn
                  ),
                ),
                const SizedBox(width: PSizes.md),

                // Mã giảm giá
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon.couponCode,
                        style: Theme.of(context).textTheme.titleMedium!.apply(
                              color: textColor,
                            ),
                      ),
                      Text(
                        'Giảm $discountText',
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),

                // Checkbox khi được chọn
                if (isSelected)
                  const Icon(Iconsax.tick_circle,
                      color: PColors.primary, size: 20),
              ],
            ),

            const SizedBox(height: PSizes.sm),

            // Chi tiết về mã giảm giá
            if (coupon.description.isNotEmpty)
              Text(
                coupon.description,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: textColor,
                    ),
              ),

            const SizedBox(height: PSizes.xs),

            // Thông tin về giá trị tối thiểu và ngày hết hạn
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: (isValid
                            ? (dark ? PColors.light : PColors.darkGrey)
                            : Colors.grey)
                        .withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.wallet_2,
                    size: 16,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: PSizes.sm),
                Expanded(
                  child: Text(
                    'Đơn tối thiểu: ${PHelperFunctions.formatCurrency(coupon.minimumPurchaseAmount)}',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: textColor,
                        ),
                  ),
                ),
              ],
            ),

            if (coupon.endDate != null) ...[
              const SizedBox(height: PSizes.sm),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: (isValid
                              ? (dark ? PColors.light : PColors.darkGrey)
                              : Colors.grey)
                          .withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.calendar_1,
                      size: 16,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: PSizes.sm),
                  Text(
                    'Hết hạn: ${coupon.formattedEndDate}',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: textColor,
                        ),
                  ),
                ],
              ),
            ],

            // Thông báo nếu chưa đủ điều kiện
            if (!isValid) ...[
              const SizedBox(height: PSizes.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: PSizes.xs,
                  horizontal: PSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.warning_2,
                      color: Colors.red,
                      size: 14,
                    ),
                    const SizedBox(width: PSizes.xs),
                    Text(
                      'Chưa đủ điều kiện áp dụng',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

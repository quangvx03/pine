import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/loaders/animation_loader.dart';
import 'package:pine/features/shop/controllers/product/coupon_controller.dart';
import 'package:pine/features/shop/models/coupon_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class UserCouponsScreen extends StatelessWidget {
  const UserCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());
    final dark = PHelperFunctions.isDarkMode(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAvailableCoupons();
    });

    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        title: Text(
          'Mã giảm giá của tôi',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.availableCoupons.isEmpty) {
          return Center(
            child: PAnimationLoaderWidget(
              text: 'Bạn chưa có mã giảm giá nào',
              animation: PImages.empty,
              showAction: false,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Danh sách mã giảm giá có thể sử dụng',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: PSizes.spaceBtwItems),

              Text(
                'Sử dụng mã giảm giá khi thanh toán để được giảm giá',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Danh sách mã giảm giá
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.availableCoupons.length,
                itemBuilder: (context, index) {
                  final coupon = controller.availableCoupons[index];
                  return _buildCouponCard(context, coupon, dark);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCouponCard(BuildContext context, CouponModel coupon, bool dark) {
    final isCouponFixed = coupon.type == 'Cố định';
    final discountText = isCouponFixed
        ? PHelperFunctions.formatCurrency(coupon.discountAmount)
        : '${coupon.discountAmount.toStringAsFixed(0)}%';

    final Color textColor = dark ? PColors.light : PColors.dark;

    return PRoundedContainer(
      margin: const EdgeInsets.only(bottom: PSizes.spaceBtwItems),
      backgroundColor: dark ? PColors.darkerGrey : PColors.white,
      showBorder: true,
      borderColor: Colors.grey.shade300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần header với mã giảm giá
          Container(
            padding: const EdgeInsets.all(PSizes.md),
            decoration: BoxDecoration(
              color: PColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(PSizes.cardRadiusLg - 1),
                topRight: Radius.circular(PSizes.cardRadiusLg - 1),
              ),
            ),
            child: Row(
              children: [
                // Icon dựa vào loại giảm giá
                Container(
                  decoration: BoxDecoration(
                    color: PColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(PSizes.sm),
                  child: Icon(
                    isCouponFixed ? Iconsax.money : Iconsax.percentage_square,
                    color: PColors.primary,
                    size: 20,
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
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        'Giảm $discountText',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: PColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Phần body
          Padding(
            padding: const EdgeInsets.all(PSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mô tả nếu có
                if (coupon.description.isNotEmpty) ...[
                  Text(
                    coupon.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: PSizes.spaceBtwItems),
                ],

                // Đơn hàng tối thiểu
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: (dark ? PColors.light : PColors.darkGrey)
                            .withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.wallet_2,
                        color: textColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: PSizes.sm),
                    Text(
                        'Đơn tối thiểu: ${PHelperFunctions.formatCurrency(coupon.minimumPurchaseAmount)}',
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: textColor,
                                )),
                  ],
                ),

                // Ngày hết hạn
                if (coupon.endDate != null) ...[
                  const SizedBox(height: PSizes.sm),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: (dark ? PColors.light : PColors.darkGrey)
                              .withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.calendar_1,
                          color: textColor,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: PSizes.sm),
                      Text(
                        'Hết hạn: ${coupon.formattedEndDate}',
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: textColor,
                                ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

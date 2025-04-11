import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/features/shop/controllers/product/coupon_controller.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:pine/utils/helpers/pricing_calculator.dart';

class PBillingAmountSection extends StatelessWidget {
  const PBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final couponController = Get.find<CouponController>();

    return Obx(() {
      // Lấy tổng giá trị của các sản phẩm đã chọn
      final subTotal = cartController.selectedItemsPrice.value;

      // Tính phí vận chuyển
      final shippingFee = double.parse(
          PPricingCalculator.calculateShippingCost(subTotal, 'VN'));

      // Tính giảm giá từ mã
      final discountAmount = couponController.calculateDiscount(subTotal);

      // Tính tổng đơn hàng
      final totalAmount = subTotal + shippingFee - discountAmount;

      return Column(
        children: [
          PSectionHeading(
            title: 'Chi tiết thanh toán',
            showActionButton: false,
          ),
          const SizedBox(height: PSizes.spaceBtwItems / 2),

          /// Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tạm tính', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                PHelperFunctions.formatCurrency(subTotal),
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwItems / 2),

          /// Shipping fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Phí vận chuyển',
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(
                PHelperFunctions.formatCurrency(shippingFee),
                style: Theme.of(context).textTheme.labelLarge,
              )
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwItems / 2),

          /// Coupon Discount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mã giảm giá',
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(
                discountAmount > 0
                    ? '- ${PHelperFunctions.formatCurrency(discountAmount)}'
                    : '0₫',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: discountAmount > 0 ? Colors.green : null,
                    ),
              )
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwItems / 2),

          /// Order total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng đơn hàng',
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(
                PHelperFunctions.formatCurrency(totalAmount),
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwItems / 2),
        ],
      );
    });
  }
}

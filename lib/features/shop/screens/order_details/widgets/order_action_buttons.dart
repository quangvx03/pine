import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/shop/controllers/product/order_controller.dart';
import 'package:pine/features/shop/models/order_model.dart';
import 'package:pine/features/shop/screens/product_reviews/widgets/product_select_review.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';

class ActionButton extends StatelessWidget {
  final OrderModel order;

  const ActionButton({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.amber.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(vertical: PSizes.md),
          foregroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PSizes.buttonRadius),
          ),
        ),
        onPressed: () => Get.to(() => ProductSelectReviewScreen(order: order)),
        icon: const Icon(Iconsax.star1, color: Colors.amber),
        label: Text(
          'Đánh giá sản phẩm',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final OrderModel order;
  final RxBool refreshValue;

  const CancelButton({
    super.key,
    required this.order,
    required this.refreshValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(vertical: PSizes.md),
          foregroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PSizes.buttonRadius),
          ),
        ),
        onPressed: () {
          Get.defaultDialog(
            contentPadding: const EdgeInsets.all(PSizes.md),
            title: 'Xác nhận hủy đơn',
            content: Column(
              children: [
                const Text('Bạn có chắc chắn muốn hủy đơn hàng này?'),
                const SizedBox(height: PSizes.sm),
                Text(
                  'Mã đơn: ${order.id}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            confirm: ElevatedButton(
              onPressed: () async {
                Get.back();

                final controller = Get.find<OrderController>();
                final success = await controller.cancelOrder(order.id);

                if (success) {
                  refreshValue.toggle();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PColors.error,
                side: const BorderSide(color: PColors.error),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: PSizes.lg),
                child: Text('Hủy'),
              ),
            ),
            cancel: OutlinedButton(
              child: const Text('Giữ lại'),
              onPressed: () => Get.back(),
            ),
          );
        },
        icon: const Icon(Iconsax.close_circle, color: Colors.red),
        label: Text(
          'Hủy đơn hàng',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

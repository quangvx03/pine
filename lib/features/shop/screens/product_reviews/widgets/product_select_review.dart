import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/features/shop/controllers/review_controller.dart';
import 'package:pine/features/shop/models/cart_model.dart';
import 'package:pine/features/shop/models/order_model.dart';
import 'package:pine/features/shop/screens/product_reviews/widgets/write_review.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class ProductSelectReviewScreen extends StatelessWidget {
  const ProductSelectReviewScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    final controller = Get.put(ReviewController());

    // Chuẩn bị dữ liệu khi màn hình được mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.prepareForReview(order);
    });

    return Scaffold(
      appBar: PAppBar(
        title: Text('Chọn sản phẩm để đánh giá',
            style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: Obx(() {
        if (controller.reviewableProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.star_slash, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: PSizes.spaceBtwItems),
                Text(
                  'Bạn đã đánh giá tất cả sản phẩm',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: PSizes.spaceBtwItems / 2),
                Text(
                  'Cảm ơn bạn đã đánh giá các sản phẩm',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          itemCount: controller.reviewableProducts.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: PSizes.spaceBtwItems),
          itemBuilder: (context, index) {
            final product = controller.reviewableProducts[index];
            return _buildProductCard(context, product, dark);
          },
        );
      }),
    );
  }

  Widget _buildProductCard(BuildContext context, CartModel product, bool dark) {
    return GestureDetector(
      onTap: () =>
          Get.to(() => WriteReviewScreen(product: product, orderId: order.id)),
      child: PRoundedContainer(
        padding: const EdgeInsets.all(PSizes.md),
        backgroundColor: dark ? PColors.darkerGrey : PColors.light,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm
            ClipRRect(
              borderRadius: BorderRadius.circular(PSizes.sm),
              child: Image.network(
                product.image ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Iconsax.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: PSizes.spaceBtwItems),

            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: PSizes.xs),

                  // Biến thể (nếu có)
                  if (product.selectedVariation != null &&
                      product.selectedVariation!.isNotEmpty) ...[
                    const SizedBox(height: PSizes.xs),
                    _buildVariationInfo(context, product.selectedVariation!),
                  ]
                ],
              ),
            ),

            // Icon bên phải
            const Icon(Iconsax.arrow_right_3, size: 18),
          ],
        ),
      ),
    );
  }
}

Widget _buildVariationInfo(
    BuildContext context, Map<String, String> variations) {
  final attributeOrder = ['Thể loại', 'Kích cỡ', 'Màu sắc', 'Chất liệu'];
  final dark = PHelperFunctions.isDarkMode(context);

  final orderedVariations = attributeOrder
      .where((attr) => variations.containsKey(attr))
      .map((key) => MapEntry(key, variations[key]!))
      .toList();

  for (final entry in variations.entries) {
    if (!attributeOrder.contains(entry.key)) {
      orderedVariations.add(entry);
    }
  }

  return Wrap(
    spacing: 4,
    runSpacing: 4,
    children: orderedVariations.map((entry) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${entry.key}: ',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            TextSpan(
              text: entry.value,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: dark ? PColors.grey : PColors.darkerGrey),
            ),
          ],
        ),
      );
    }).toList(),
  );
}

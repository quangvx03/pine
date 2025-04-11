import 'package:flutter/material.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/shimmers/product_detail_shimmer.dart';
import 'package:pine/data/repositories/product_repository.dart';
import 'package:pine/features/shop/models/order_model.dart';
import 'package:pine/features/shop/screens/order_details/widgets/order_summary.dart';
import 'package:pine/features/shop/screens/product_details/product_detail.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class OrderInfoCard extends StatelessWidget {
  final OrderModel order;
  final String orderDate;
  final String orderTime;
  final bool dark;
  final double subtotal;
  final double shippingFee;
  final double discount;

  const OrderInfoCard({
    super.key,
    required this.order,
    required this.orderDate,
    required this.orderTime,
    required this.dark,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(PSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mã đơn hàng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mã đơn hàng',
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(
                order.id,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PColors.primary,
                    ),
              ),
            ],
          ),

          // Thanh ngang ngăn cách
          Container(
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            height: 1,
            color: Colors.grey.shade200,
          ),

          // Ngày đặt hàng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ngày đặt hàng',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                '$orderDate, $orderTime',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),

          // Thanh ngang ngăn cách
          Container(
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            height: 1,
            color: Colors.grey.shade200,
          ),

          // Phương thức thanh toán
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phương thức thanh toán',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: PSizes.lg),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: PSizes.md, vertical: 4),
                  decoration: BoxDecoration(
                    color: PColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(PSizes.xs),
                  ),
                  child: Text(
                    order.paymentMethod,
                    style: TextStyle(
                      color: PColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),

          // Separator giữa thông tin và sản phẩm
          const SizedBox(height: PSizes.spaceBtwItems),
          Container(
            height: 3,
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            decoration: BoxDecoration(
              color: dark
                  ? PColors.black.withValues(alpha: 0.7)
                  : PColors.darkGrey,
              borderRadius: BorderRadius.circular(PSizes.borderRadiusSm),
            ),
          ),
          const SizedBox(height: PSizes.sm),

          // Tiêu đề sản phẩm với count badge
          Row(
            children: [
              Text(
                'Sản phẩm đã đặt',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: PSizes.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: PColors.grey.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${order.items.length}',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: PColors.primary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PSizes.sm),

          // Danh sách sản phẩm
          _buildOrderItemsList(context),

          // Separator giữa sản phẩm và tổng kết
          const SizedBox(height: PSizes.spaceBtwItems),
          Container(
            height: 3,
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            decoration: BoxDecoration(
              color: dark
                  ? PColors.black.withValues(alpha: 0.7)
                  : PColors.darkGrey,
              borderRadius: BorderRadius.circular(PSizes.borderRadiusSm),
            ),
          ),
          const SizedBox(height: PSizes.sm),

          // Tổng kết
          OrderSummary(
            subtotal: subtotal,
            shippingFee: shippingFee,
            total: order.totalAmount,
            discount: discount,
            couponCode: order.couponCode,
          ),
        ],
      ),
    );
  }

  // Danh sách các sản phẩm trong đơn hàng
  Widget _buildOrderItemsList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.items.length,
      separatorBuilder: (_, __) => Container(
        height: 1,
        margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
        color: dark ? Colors.grey.shade800 : Colors.grey.shade200,
      ),
      itemBuilder: (_, index) {
        final item = order.items[index];

        // Danh sách thứ tự ưu tiên các thuộc tính
        final attributeOrder = ['Thể loại', 'Kích cỡ', 'Màu sắc', 'Chất liệu'];

        // Tạo danh sách các thuộc tính đã được sắp xếp
        final Map<String, String> variations = item.selectedVariation ?? {};
        final orderedVariations = attributeOrder
            .where((attr) => variations.containsKey(attr))
            .map((key) => MapEntry(key, variations[key]!))
            .toList();

        // Thêm các thuộc tính khác không nằm trong danh sách ưu tiên
        for (final entry in variations.entries) {
          if (!attributeOrder.contains(entry.key)) {
            orderedVariations.add(entry);
          }
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductDetailShimmer(),
                ));
            _loadProductDetails(context, item.productId);
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hình ảnh sản phẩm
                  PRoundedImage(
                    imageUrl: item.image ?? '',
                    width: 65,
                    height: 65,
                    isNetworkImage: true,
                    padding: const EdgeInsets.all(PSizes.xs),
                    backgroundColor: dark ? PColors.darkerGrey : PColors.light,
                  ),

                  const SizedBox(width: PSizes.sm),

                  // Thông tin sản phẩm
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên sản phẩm
                        Text(
                          item.title,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.visible,
                        ),

                        // Hiển thị các biến thể theo thứ tự ưu tiên
                        if (orderedVariations.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: orderedVariations
                                .map((e) => Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${e.key}: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                          TextSpan(
                                            text: e.value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),

                        const SizedBox(height: 4),

                        // Giá và số lượng
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${PHelperFunctions.formatCurrency(item.price)} × ${item.quantity}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: dark
                                        ? Colors.white70
                                        : Colors.grey.shade600,
                                  ),
                            ),
                            Text(
                              PHelperFunctions.formatCurrency(
                                  item.price * item.quantity),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: PColors.primary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _loadProductDetails(BuildContext context, String productId) async {
  try {
    final productRepository = ProductRepository.instance;
    final product = await productRepository.getProductById(productId);

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Không thể tải thông tin sản phẩm: $e'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PSizes.borderRadiusSm),
        ),
      ),
    );
    Navigator.pop(context);
  }
}

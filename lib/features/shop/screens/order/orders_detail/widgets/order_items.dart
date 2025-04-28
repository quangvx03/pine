import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'vi_VN', decimalDigits: 0);
    final subTotal = order.items.fold(0.0, (prev, item) => prev + (item.price * item.quantity));

    return PRoundedContainer(
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sản phẩm', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: PSizes.spaceBtwSections),

          // Danh sách sản phẩm
          ListView.separated(
            shrinkWrap: true,
            itemCount: order.items.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: PSizes.spaceBtwItems),
            itemBuilder: (_, index) {
              final item = order.items[index];
              return Row(
                children: [
                  // Ảnh sản phẩm + Tên
                  Expanded(
                    child: Row(
                      children: [
                        PRoundedImage(
                          backgroundColor: PColors.primaryBackground,
                          imageType: item.image != null ? ImageType.network : ImageType.asset,
                          image: item.image ?? PImages.defaultImage,
                        ),
                        const SizedBox(width: PSizes.spaceBtwItems),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (item.selectedVariation != null)
                                Text(
                                  item.selectedVariation!.entries.map((e) => '${e.key}: ${e.value}').join(', '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: PSizes.spaceBtwItems),

                  // Giá tiền
                  SizedBox(
                    width: PSizes.xl * 3,
                    child: Text(
                      currencyFormatter.format(item.price),
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.right,
                    ),
                  ),

                  // Số lượng
                  SizedBox(
                    width: PDeviceUtils.isMobileScreen(context) ? PSizes.xl * 1.4 : PSizes.xl * 2,
                    child: Text(
                      'x${item.quantity}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Thành tiền
                  SizedBox(
                    width: PDeviceUtils.isMobileScreen(context) ? PSizes.xl * 2 : PSizes.xl * 2.5,
                    child: Text(
                      currencyFormatter.format(item.totalAmount),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: PSizes.spaceBtwSections),

          // Tổng kết đơn hàng
          PRoundedContainer(
            padding: const EdgeInsets.all(PSizes.defaultSpace),
            backgroundColor: PColors.primaryBackground,
            child: Column(
              children: [
                _buildSummaryRow(context, 'Tạm tính', currencyFormatter.format(subTotal)),
                const SizedBox(height: PSizes.spaceBtwItems),
                _buildSummaryRow(context, 'Giảm giá', '- ${currencyFormatter.format(order.discountAmount)}'),
                const SizedBox(height: PSizes.spaceBtwItems),
                _buildSummaryRow(context, 'Phí vận chuyển', currencyFormatter.format(order.shippingCost)),
                const SizedBox(height: PSizes.spaceBtwItems),
                const Divider(),
                const SizedBox(height: PSizes.spaceBtwItems),
                _buildSummaryRow(
                  context,
                  'Tổng',
                  currencyFormatter.format(order.totalAmount),
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? PColors.primary : null,
          ),
        ),
      ],
    );
  }
}

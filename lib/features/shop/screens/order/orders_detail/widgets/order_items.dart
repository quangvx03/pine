import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';
import 'package:pine_admin_panel/utils/helpers/pricing_calculator.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final subTotal = order.items.fold(0.0, (previousValue, element) => previousValue + (element.price * element.quantity));
    return PRoundedContainer(
      padding: const  EdgeInsets.all(PSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sản phẩm', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: PSizes.spaceBtwSections),

          // Items
          ListView.separated(
              shrinkWrap: true,
            itemCount: order.items.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: PSizes.spaceBtwItems),
            itemBuilder: (_, index) {
                final item = order.items[index];
                return Row(
                  children: [
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
                                      Text(item.selectedVariation!.entries.map((e) => ('${e.key} : ${e.value} ')).toString())
                                  ],
                                )
                            )
                          ],
                        )
                    ),
                    const SizedBox(width: PSizes.spaceBtwItems),
                    SizedBox(
                      width: PSizes.xl * 2,
                      child: Text('${item.price.toStringAsFixed(1)}đ', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    SizedBox(
                      width: PDeviceUtils.isMobileScreen(context) ? PSizes.xl * 1.4 : PSizes.xl * 2,
                      child: Text(item.quantity.toString(), style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    SizedBox(
                      width: PDeviceUtils.isMobileScreen(context) ? PSizes.xl * 1.4 : PSizes.xl * 2,
                      child: Text('${item.totalAmount}đ', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ],
                );
            },
          ),
          const SizedBox(height: PSizes.spaceBtwSections),

          // Items Total
          PRoundedContainer(
            padding: const EdgeInsets.all(PSizes.defaultSpace),
            backgroundColor: PColors.primaryBackground,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tạm tính', style: Theme.of(context).textTheme.titleLarge),
                    Text('$subTotalđ', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: PSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Giảm giá', style: Theme.of(context).textTheme.titleLarge),
                    Text('0đ', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: PSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Phí vận chuyển', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                        '${PPricingCalculator.calculateShippingCost(subTotal, '')}đ',
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: PSizes.spaceBtwItems),
                const Divider(),
                const SizedBox(height: PSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                        '${PPricingCalculator.calculateTotalPrice(subTotal, '')}đ',
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

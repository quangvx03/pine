import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/loaders/animation_loader.dart';
import 'package:pine/features/shop/controllers/product/order_controller.dart';
import 'package:pine/navigation_menu.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/cloud_helper_functions.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class POrderListItems extends StatelessWidget {
  const POrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    return FutureBuilder(
      future: controller.fetchUserOrders(),
      builder: (_, snapshot) {
        /// Nothing found widget
        final emptyWidget = SizedBox(
            height: PHelperFunctions.screenHeight() * 0.7,
            child: Center(
                child: PAnimationLoaderWidget(
              text: 'Chưa có đơn đặt hàng nào!',
              animation: PImages.empty,
              showAction: true,
              actionText: 'Khám phá ngay',
              onActionPressed: () {
                final navController = Get.find<NavigationController>();
                Get.back();
                navController.navigateToTab(0);
              },
            )));

        /// Handle loader, no record, or error message
        final response = PCloudHelperFunctions.checkMultiRecordState(
            snapshot: snapshot, nothingFound: emptyWidget);
        if (response != null) return response;

        /// Congratulations Record found
        final orders = snapshot.data!;
        return ListView.separated(
            shrinkWrap: true,
            itemCount: orders.length,
            separatorBuilder: (_, index) =>
                const SizedBox(height: PSizes.spaceBtwItems),
            itemBuilder: (_, index) {
              final order = orders[index];
              return PRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(PSizes.md),
                backgroundColor: PHelperFunctions.isDarkMode(context)
                    ? PColors.dark
                    : PColors.light,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        /// Icon
                        const Icon(Icons.local_shipping_outlined),
                        const SizedBox(width: PSizes.spaceBtwItems / 2),

                        /// Status & Date
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.orderStatusText,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(
                                        color: PColors.primary,
                                        fontWeightDelta: 1),
                              ),
                              Text(order.formattedOrderDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                            ],
                          ),
                        ),

                        /// Icon
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Iconsax.arrow_right_34,
                                size: PSizes.iconSm)),
                      ],
                    ),
                    const SizedBox(height: PSizes.spaceBtwItems),

                    /// Bottom Row
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              /// Icon
                              const Icon(Iconsax.tag),
                              const SizedBox(width: PSizes.spaceBtwItems / 2),

                              /// Status & Date
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Đơn hàng',
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                    Text(order.id,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Row(
                                  children: [
                                    /// Icon
                                    const Icon(Iconsax.dollar_circle),
                                    const SizedBox(
                                        width: PSizes.spaceBtwItems / 2),

                                    /// Status & Date
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Giá trị',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium),
                                          Text(
                                              PHelperFunctions.formatCurrency(
                                                  order.totalAmount.toString()),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}

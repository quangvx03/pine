import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/common/widgets/loaders/animation_loader.dart';
import 'package:pine_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:pine_admin_panel/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';

import '../../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../table/customer_data_table.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerDetailController.instance;
    controller.getCustomerOrders();
    final currencyFormatter = NumberFormat("#,###", "vi_VN");

    return PRoundedContainer(
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Obx(
        () {
          if (controller.ordersLoading.value) return const PLoaderAnimation();
          if (controller.allCustomerOrders.isEmpty) {
            return PAnimationLoaderWidget(text: 'Không có đơn hàng nào', animation: PImages.pencilAnimation);
          }
          final totalAmount = controller.allCustomerOrders.fold(0.0, (previousValue, order) {
            final orderTotal = order.items.fold(0.0, (sum, item) => sum + item.price);
            return previousValue + orderTotal;
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tất cả đơn hàng', style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium),
                  Text.rich(
                      TextSpan(
                          children: [
                            const TextSpan(text: 'Tổng tiền '),
                            TextSpan(text: '${currencyFormatter.format(totalAmount)}đ', style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge!
                                .apply(color: PColors.primary)),
                            TextSpan(text: ' cho ${controller.allCustomerOrders.length} Đơn hàng', style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge),
                          ]
                      )
                  )
                ],
              ),
              const SizedBox(height: PSizes.spaceBtwItems),
              TextFormField(
                controller: controller.searchTextController,
                onChanged: (query) => controller.searchQuery(query),
                decoration: const InputDecoration(hintText: 'Tìm kiếm đơn hàng',
                    prefixIcon: Icon(Iconsax.search_normal)),
              ),
              const SizedBox(height: PSizes.spaceBtwSections),
              const CustomerOrderTable(),

            ],
          );
        }
      ),
    );
  }
}

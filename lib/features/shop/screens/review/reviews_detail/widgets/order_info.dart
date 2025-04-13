import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/order/order_controller.dart';


class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    controller.orderStatus.value = order.status;
    return PRoundedContainer(
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin đơn hàng', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: PSizes.spaceBtwSections),
          Row(
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ngày đặt hàng'),
                      Text(order.formattedOrderDate, style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  )
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sản phẩm'),
                      Text('${order.items.length} sản phẩm', style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  )
              ),
              Expanded(
                flex: PDeviceUtils.isMobileScreen(context) ? 2 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Trạng thái'),
                      Obx(
                        () {
                          if (controller.statusLoader.value) return const PShimmerEffect(width: double.infinity, height: 55);
                          return PRoundedContainer(
                            radius: PSizes.cardRadiusSm,
                            padding: const EdgeInsets.symmetric(
                                horizontal: PSizes.sm, vertical: 0),
                            backgroundColor: PHelperFunctions
                                .getOrderStatusColor(order.status).withValues(
                                alpha: 0.1),
                            child: DropdownButton<OrderStatus>(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              value: controller.orderStatus.value,
                              onChanged: (OrderStatus? newValue) {
                                if (newValue != null) {
                                  controller.updateOrderStatus(order, newValue);
                                }
                              },
                              items: OrderStatus.values.map((
                                  OrderStatus status) {
                                return DropdownMenuItem<OrderStatus>(
                                    value: status,
                                    child: Text(
                                      status.name.capitalize.toString(),
                                      style: TextStyle(color: PHelperFunctions
                                          .getOrderStatusColor(controller.orderStatus.value)),
                                    )
                                );
                              }).toList(),
                            ),
                          );
                        }
                      )
                    ],
                  )
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tổng'),
                      Text(order.formattedCurrency, style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  )
              ),
            ],
          ),

          ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
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
                      const Text('Ngày'),
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
                      PRoundedContainer(
                        radius: PSizes.cardRadiusSm,
                        padding: const EdgeInsets.symmetric(horizontal: PSizes.sm, vertical: 0),
                        backgroundColor: PHelperFunctions.getOrderStatusColor(OrderStatus.pending).withValues(alpha: 0.1),
                        child: DropdownButton<OrderStatus>(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                            value: OrderStatus.pending,
                            onChanged: (OrderStatus? newValue) {},
                          items: OrderStatus.values.map((OrderStatus status) {
                            return DropdownMenuItem<OrderStatus>(
                              value: status,
                                child: Text(
                                  status.name.capitalize.toString(),
                                  style: TextStyle(color: PHelperFunctions.getOrderStatusColor(OrderStatus.pending)),
                                )
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  )
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tổng'),
                      Text('${order.totalAmount}đ', style: Theme.of(context).textTheme.bodyLarge),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/features/shop/controllers/product/order_controller.dart';
import 'package:pine/features/shop/models/order_model.dart';
import 'package:pine/features/shop/screens/order_details/widgets/order_action_buttons.dart';
import 'package:pine/features/shop/screens/order_details/widgets/order_info_card.dart';
import 'package:pine/features/shop/screens/order_details/widgets/order_status_widgets.dart';
import 'package:pine/features/shop/screens/order_details/widgets/order_timeline.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:pine/utils/helpers/pricing_calculator.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    final controller = Get.put(OrderController());
    final refreshValue = false.obs;

    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        title: Row(
          children: [
            Expanded(
              child: Text('Chi tiết đơn hàng',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Text(
              orderId,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: PColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        refreshValue.value;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(PSizes.defaultSpace),
            child: FutureBuilder<List<OrderModel>>(
              future: controller.fetchUserOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Iconsax.warning_2,
                            size: 50, color: Colors.red),
                        const SizedBox(height: PSizes.spaceBtwItems),
                        Text(
                          'Có lỗi xảy ra khi tải đơn hàng',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: PSizes.spaceBtwItems),
                        ElevatedButton(
                          onPressed: () => refreshValue.toggle(),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                }

                final order = snapshot.data?.firstWhere(
                  (order) => order.id == orderId,
                  orElse: () => OrderModel(
                    id: '',
                    status: OrderStatus.pending,
                    items: [],
                    totalAmount: 0,
                    orderDate: DateTime.now(),
                  ),
                );

                if (order == null || order.id.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Iconsax.document_filter,
                            size: 60, color: Colors.grey),
                        const SizedBox(height: PSizes.spaceBtwItems),
                        Text(
                          'Không tìm thấy thông tin đơn hàng',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                }

                final dateFormat = DateFormat('dd/MM/yyyy');
                final timeFormat = DateFormat('HH:mm');
                final orderDate = dateFormat.format(order.orderDate);
                final orderTime = timeFormat.format(order.orderDate);
                String? deliveryDateTime;
                if ((order.status == OrderStatus.delivered ||
                        order.status == OrderStatus.cancelled) &&
                    order.deliveryDate != null) {
                  deliveryDateTime =
                      '${dateFormat.format(order.deliveryDate!)}, ${timeFormat.format(order.deliveryDate!)}';
                }

                final shippingFee = PPricingCalculator.getShippingCost(
                    order.address?.province ?? 'VN');

                final discount = order.discountAmount;
                final subtotal = order.totalAmount + discount - shippingFee;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thẻ trạng thái đơn hàng
                    OrderStatusCard(order: order, dark: dark),
                    const SizedBox(height: PSizes.spaceBtwSections),

                    // Tiêu đề theo dõi đơn hàng
                    buildSectionHeader(context, 'Theo dõi đơn hàng'),
                    const SizedBox(height: PSizes.spaceBtwItems),

                    // Timeline theo dõi đơn hàng
                    PRoundedContainer(
                      backgroundColor: Colors.transparent,
                      child: OrderTimeline(
                        status: order.status,
                        dark: dark,
                        orderDateTime: '$orderDate, $orderTime',
                        deliveryDateTime: deliveryDateTime,
                      ),
                    ),

                    // Địa chỉ giao hàng
                    if (order.address != null) ...[
                      buildSectionHeader(context, 'Địa chỉ giao hàng'),
                      const SizedBox(height: PSizes.spaceBtwItems),
                      PRoundedContainer(
                        backgroundColor: Colors.transparent,
                        child: DeliveryAddress(order: order, dark: dark),
                      ),
                      const SizedBox(height: PSizes.spaceBtwSections),
                    ],

                    // Thông tin đơn hàng
                    buildSectionHeader(context, 'Thông tin đơn hàng'),
                    const SizedBox(height: PSizes.spaceBtwItems),
                    OrderInfoCard(
                      order: order,
                      orderDate: orderDate,
                      orderTime: orderTime,
                      dark: dark,
                      subtotal: subtotal,
                      shippingFee: shippingFee,
                      discount: discount,
                    ),
                    const SizedBox(height: PSizes.spaceBtwSections),

                    // Các nút hành động
                    if (order.status == OrderStatus.delivered)
                      ActionButton(order: order),
                    if (order.status == OrderStatus.delivered)
                      const SizedBox(height: PSizes.spaceBtwItems),

                    if (canCancelOrder(order.status))
                      CancelButton(order: order, refreshValue: refreshValue),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }

  // Kiểm tra đơn hàng có thể hủy hay không
  bool canCancelOrder(OrderStatus status) {
    return status == OrderStatus.pending || status == OrderStatus.processing;
  }
}

// Tiêu đề section với đường viền bên trái
Widget buildSectionHeader(BuildContext context, String title) {
  return Row(
    children: [
      Container(
        width: 4,
        height: 24,
        decoration: BoxDecoration(
          color: PColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      const SizedBox(width: PSizes.sm),
      Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/loaders/animation_loader.dart';
import 'package:pine/features/shop/controllers/product/order_controller.dart';
import 'package:pine/features/shop/models/order_model.dart';
import 'package:pine/features/shop/screens/order/widgets/order_details.dart';
import 'package:pine/navigation_menu.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:intl/intl.dart';

class POrderListItems extends StatelessWidget {
  const POrderListItems({super.key, this.status});

  final OrderStatus? status;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    final dark = PHelperFunctions.isDarkMode(context);

    return FutureBuilder(
      future: controller.fetchUserOrders(),
      builder: (context, snapshot) {
        // Xử lý trạng thái loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Xử lý trạng thái lỗi
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Iconsax.warning_2, size: 50, color: Colors.red),
                const SizedBox(height: PSizes.spaceBtwItems),
                Text(
                  'Có lỗi xảy ra khi tải đơn hàng',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: PSizes.spaceBtwItems),
                ElevatedButton(
                  onPressed: () {
                    controller.fetchUserOrders();
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        // Nếu không có dữ liệu
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: PHelperFunctions.screenHeight() * 0.7,
            child: Center(
              child: PAnimationLoaderWidget(
                text: 'Danh sách đơn hàng đang trống...',
                animation: PImages.empty,
                showAction: true,
                actionText: 'Mua sắm ngay',
                onActionPressed: () {
                  final navController = Get.find<NavigationController>();
                  Get.back();
                  navController.navigateToTab(0);
                },
              ),
            ),
          );
        }

        // Lấy danh sách đơn hàng
        final orders = snapshot.data!;

        // Lọc theo trạng thái nếu có và sắp xếp theo thời gian mới nhất
        final filteredOrders = status == null
            ? orders
            : orders.where((order) => order.status == status).toList();

        // Sắp xếp theo thời gian mới nhất
        filteredOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));

        // Hiển thị thông báo khi không có đơn hàng nào ở trạng thái đang lọc
        if (filteredOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Iconsax.document_filter,
                    size: 60, color: Colors.grey),
                const SizedBox(height: PSizes.spaceBtwItems),
                Text(
                  'Không có đơn hàng ${_getStatusText(status!)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }

        // Hiển thị danh sách đơn hàng đã lọc
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: PSizes.sm),
          itemCount: filteredOrders.length,
          itemBuilder: (_, index) {
            final order = filteredOrders[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: PSizes.spaceBtwItems),
              child: _buildOrderCard(context, order, dark),
            );
          },
        );
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order, bool dark) {
    // Format đầy đủ ngày tháng
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    final orderDate = dateFormat.format(order.orderDate);
    final orderTime = timeFormat.format(order.orderDate);
    final textColor = dark ? Colors.white70 : Colors.grey.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: PSizes.sm),
      decoration: BoxDecoration(
        color: dark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(PSizes.md),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          if (!dark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header với mã đơn hàng và trạng thái
          Container(
            decoration: BoxDecoration(
              color: dark
                  ? Colors.grey.shade700.withValues(alpha: 0.3)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(PSizes.md - 1),
                topRight: Radius.circular(PSizes.md - 1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Mã đơn hàng
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () =>
                        Get.to(() => OrderDetailsScreen(orderId: order.id)),
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: PSizes.md, vertical: PSizes.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: dark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Iconsax.receipt_item,
                              size: 18,
                              color:
                                  dark ? Colors.white70 : Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(width: PSizes.sm),

                          // Mã đơn hàng - kích thước lớn hơn
                          Expanded(
                            child: Text(
                              'Đơn ${order.id.substring(0, 8)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: dark ? PColors.light : PColors.dark,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Trạng thái đơn hàng - căn đều với bên trái
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: PSizes.md, vertical: PSizes.sm),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _buildStatusIndicator(context, order.status),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hình ảnh sản phẩm - Giữ nguyên giao diện nhưng thêm scrolling
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PSizes.md,
              vertical: PSizes.sm,
            ),
            child: SizedBox(
              height: 70,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Hiển thị tất cả sản phẩm có thể cuộn ngang
                    ...List.generate(
                      order.items.length,
                      (index) {
                        final item = order.items[index];
                        return Container(
                          padding: const EdgeInsets.all(PSizes.xs),
                          margin: const EdgeInsets.only(right: PSizes.sm),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(PSizes.sm),
                          ),
                          width: 70,
                          height: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(PSizes.sm - 1),
                            child: Image.network(
                              item.image ?? '',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: Icon(
                                  Iconsax.image,
                                  color: Colors.grey.shade500,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Nội dung đơn hàng
          GestureDetector(
            onTap: () => Get.to(() => OrderDetailsScreen(orderId: order.id)),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(PSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ngày đặt hàng
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: dark ? PColors.darkerGrey : PColors.light,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Iconsax.calendar_2,
                            size: 16,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: PSizes.sm),
                        Text(
                          orderDate,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color:
                                    dark ? PColors.light : PColors.darkerGrey,
                              ),
                        ),
                        const SizedBox(width: PSizes.md),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: dark ? PColors.darkerGrey : PColors.light,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Iconsax.clock,
                            size: 16,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: PSizes.sm),
                        Text(
                          orderTime,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color:
                                    dark ? PColors.light : PColors.darkerGrey,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: PSizes.sm),

                  // Tổng tiền và nút Xem chi tiết trong cùng một hàng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Phần hiển thị tổng tiền - giới hạn chiều rộng
                      Expanded(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color:
                                    dark ? PColors.darkerGrey : PColors.light,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.dollar_circle,
                                size: 16,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: PSizes.sm),
                            Expanded(
                              child: Text(
                                PHelperFunctions.formatCurrency(
                                    order.totalAmount),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          dark ? PColors.light : PColors.dark,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Nút xem chi tiết - loại bỏ padding ngang và container bên ngoài
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Xem chi tiết',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: PColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Iconsax.arrow_right_3,
                            size: 16,
                            color: PColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị trạng thái đơn hàng
  Widget _buildStatusIndicator(BuildContext context, OrderStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        text = 'Chờ xử lý';
        icon = Iconsax.timer_1;
        break;
      case OrderStatus.processing:
        color = Colors.blue;
        text = 'Đang xử lý';
        icon = Iconsax.box_1;
        break;
      case OrderStatus.shipped:
        color = Colors.purple;
        text = 'Đang giao';
        icon = Iconsax.truck_fast;
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        text = 'Đã giao';
        icon = Iconsax.tick_circle;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        text = 'Đã hủy';
        icon = Iconsax.close_circle;
        break;
    }

    return PRoundedContainer(
      radius: PSizes.sm,
      backgroundColor: color.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(
          horizontal: PSizes.xs, vertical: PSizes.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 2),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall!.apply(
                  color: color,
                  fontWeightDelta: 1,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Helper để lấy text dựa trên trạng thái
  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'chờ xử lý';
      case OrderStatus.processing:
        return 'đang xử lý';
      case OrderStatus.shipped:
        return 'đang giao';
      case OrderStatus.delivered:
        return 'đã giao';
      case OrderStatus.cancelled:
        return 'đã hủy';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';  // Import intl package

import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/table/dashboard_table.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/widgets/dashboard_card.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/widgets/order_status_graph.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/widgets/weekly_sales.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../utils/constants/enums.dart';

class DashboardDesktopScreen extends StatelessWidget {
  const DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    // Hàm format tiền tệ Việt Nam
    String formatCurrency(double value) {
      final formatter = NumberFormat("#,##0", "vi_VN");
      return "${formatter.format(value)} đ";
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text('Bảng điều khiển', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Cards
              Row(
                children: [
                  Flexible(
                    child: Obx(() {
                      final filteredOrders = controller.orderController.allItems
                          .where((order) => order.status != OrderStatus.cancelled)
                          .toList();

                      final totalRevenue = filteredOrders.fold(0.0, (previousValue, element) => previousValue + element.totalAmount);

                      return PDashboardCard(
                        headingIcon: Iconsax.note,
                        headingIconColor: Colors.blue,
                        headingIconBgColor: Colors.blue.withValues(alpha: 0.1),
                        context: context,
                        title: 'Tổng doanh số',
                        subTitle: formatCurrency(totalRevenue),
                        stats: 25,
                      );
                    }),
                  ),
                  const SizedBox(width: PSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                          () => PDashboardCard(
                        headingIcon: Iconsax.external_drive,
                        headingIconColor: Colors.green,
                        headingIconBgColor: Colors.green.withValues(alpha: 0.1),
                        context: context,
                        title: 'Giá trị đơn hàng trung bình',
                        subTitle: controller.orderController.allItems.isNotEmpty
                            ? formatCurrency(
                            controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount) /
                                controller.orderController.allItems.length)
                            : '0.00 đ',
                        stats: 15,
                        icon: Iconsax.arrow_down,
                        color: PColors.error,
                      ),
                    ),
                  ),
                  SizedBox(width: PSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                          () => PDashboardCard(
                        headingIcon: Iconsax.box,
                        headingIconColor: Colors.deepPurple,
                        headingIconBgColor: Colors.deepPurple.withValues(alpha: 0.1),
                        context: context,
                        title: 'Tổng đơn hàng',
                        subTitle: '${controller.orderController.allItems.length}',
                        stats: 44,
                      ),
                    ),
                  ),
                  SizedBox(width: PSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                          () => PDashboardCard(
                        headingIcon: Iconsax.user,
                        headingIconColor: Colors.deepOrange,
                        headingIconBgColor: Colors.deepOrange.withValues(alpha: 0.1),
                        context: context,
                        title: 'Người dùng',
                        subTitle: '${controller.customerController.allItems.length}',
                        stats: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// GRAPHS
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        /// Bar Graph
                        const PWeeklySalesGraph(),
                        const SizedBox(height: PSizes.spaceBtwSections),

                        /// Orders
                        PRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Đơn hàng gần đây', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: PSizes.spaceBtwSections),
                              const DashboardOrderTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: PSizes.spaceBtwSections),

                  /// Pie Chart
                  const Expanded(child: OrderStatusPieChart()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

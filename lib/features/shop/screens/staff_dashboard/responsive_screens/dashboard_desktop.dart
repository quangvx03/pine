import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../dashboard/table/dashboard_table.dart';
import '../../dashboard/widgets/dashboard_card.dart';
import '../../dashboard/widgets/order_status_graph.dart';
import '../../dashboard/widgets/weekly_sales.dart';

class StaffDashboardDesktopScreen extends StatelessWidget {
  const StaffDashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

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
                    child: Obx(
                          () => PDashboardCard(
                        headingIcon: Iconsax.note,
                        headingIconColor: Colors.blue,
                        headingIconBgColor: Colors.blue.withValues(alpha: 0.1),
                        context: context,
                        title: 'Tổng sản phẩm',
                        subTitle: '${controller.totalProductInStock}',
                        stats: 25,
                      ),
                    ),
                  ),
                  const SizedBox(width: PSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                          () => PDashboardCard(
                        headingIcon: Iconsax.box_tick,
                        headingIconColor: Colors.deepOrange,
                        headingIconBgColor: Colors.deepOrange.withValues(alpha: 0.1),
                        context: context,
                        title: 'Tổng sản phẩm đã bán',
                        subTitle: '${controller.totalProductSold}',
                        stats: 2,
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:pine_admin_panel/features/shop/screens/staff_dashboard/table/best_seller_table.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../common/widgets/icons/p_circular_icon.dart';
import '../../dashboard/table/dashboard_table.dart';
import '../../dashboard/widgets/dashboard_card.dart';
import '../../dashboard/widgets/order_status_graph.dart';

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
                  // Cột bên trái chứa "Đơn hàng gần đây" và "Sản phẩm bán chạy"
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        /// Đơn hàng gần đây
                        PRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  PCircularIcon(
                                    icon: Iconsax.box_search,
                                    backgroundColor: Colors.pinkAccent.withOpacity(0.1),
                                    color: Colors.pinkAccent,
                                    size: PSizes.md,
                                  ),
                                  const SizedBox(width: PSizes.spaceBtwItems),
                                  Text('Đơn hàng gần đây', style: Theme.of(context).textTheme.headlineSmall),
                                ],
                              ),
                              const SizedBox(height: PSizes.spaceBtwSections),
                              const DashboardOrderTable(),
                            ],
                          ),
                        ),

                        // Thêm khoảng cách sau đơn hàng gần đây
                        const SizedBox(height: PSizes.spaceBtwSections),

                        /// Sản phẩm bán chạy
                        PRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  PCircularIcon(
                                    icon: Iconsax.chart_square,
                                    backgroundColor: Colors.green.withOpacity(0.1),
                                    color: Colors.green,
                                    size: PSizes.md,
                                  ),
                                  const SizedBox(width: PSizes.spaceBtwItems),
                                  Text('Sản phẩm bán chạy', style: Theme.of(context).textTheme.headlineSmall),
                                ],
                              ),
                              const SizedBox(height: PSizes.spaceBtwSections),
                              const BestSellerTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: PSizes.spaceBtwSections),

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

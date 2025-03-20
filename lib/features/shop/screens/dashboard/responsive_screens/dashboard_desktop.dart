import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product_images_controller.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/table/dashboard_table.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/widgets/dashboard_card.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/widgets/order_status_graph.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/widgets/weekly_sales.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class DashboardDesktopScreen extends StatelessWidget {
  const DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final controller = Get.put(ProductImagesController());
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(PSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading
                  Text('Bảng điều khiển', style: Theme.of(context).textTheme.headlineLarge),
                  //ElevatedButton(onPressed: () => controller.selectThumbnailImage(), child: Text('Chọn hình ảnh')),
                  //ElevatedButton(onPressed: () => controller.selectMultipleProductImages(), child: Text('Chọn nhiều hình ảnh')),
                  const SizedBox(height: PSizes.spaceBtwSections),

                  // Cards
                  Row(
                    children: [
                      Expanded(child: PDashboardCard(title: 'Tổng doanh số', subTitle: '250,000đ', stats: 25)),
                      SizedBox(width: PSizes.spaceBtwItems),
                      Expanded(child: PDashboardCard(title: 'Giá trị đơn hàng trung bình', subTitle: '100,000đ', stats: 15)),
                      SizedBox(width: PSizes.spaceBtwItems),
                      Expanded(child: PDashboardCard(title: 'Tổng đơn hàng', subTitle: '36', stats: 44)),
                      SizedBox(width: PSizes.spaceBtwItems),
                      Expanded(child: PDashboardCard(title: 'Người dùng', subTitle: '25,035', stats: 2)),
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
                  )
                ],
              ),
            ),
        ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/widgets/order_status_graph.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/widgets/weekly_sales.dart';

import '../../../../../utils/constants/sizes.dart';
import '../table/dashboard_table.dart';
import '../widgets/dashboard_card.dart';

class DashboardTabletScreen extends StatelessWidget {
  const DashboardTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(PSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                Text('Bảng điều khiển', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: PSizes.spaceBtwSections),

                // Cards
                const Row(
                  children: [
                    Expanded(child: PDashboardCard(title: 'Tổng doanh số', subTitle: '250,000đ', stats: 25)),
                    SizedBox(width: PSizes.spaceBtwItems),
                    Expanded(child: PDashboardCard(title: 'Giá trị đơn hàng trung bình', subTitle: '100,000đ', stats: 15)),
                  ],
                ),
                const SizedBox(height: PSizes.spaceBtwItems),
                const Row(
                  children: [
                    Expanded(child: PDashboardCard(title: 'Tổng đơn hàng', subTitle: '36', stats: 44)),
                    SizedBox(width: PSizes.spaceBtwItems),
                    Expanded(child: PDashboardCard(title: 'Người dùng', subTitle: '25,035', stats: 2)),
                  ],
                ),
                const SizedBox(height: PSizes.spaceBtwSections),

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
                const SizedBox(height: PSizes.spaceBtwSections),

                /// Pie Chart
                const OrderStatusPieChart(),
              ],
            ),
        ),
      ),
    );
  }
}

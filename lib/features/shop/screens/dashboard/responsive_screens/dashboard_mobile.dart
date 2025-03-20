import 'package:flutter/material.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/sizes.dart';
import '../table/dashboard_table.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/order_status_graph.dart';
import '../widgets/weekly_sales.dart';

class DashboardMobileScreen extends StatelessWidget {
  const DashboardMobileScreen({super.key});

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
          const PDashboardCard(title: 'Tổng doanh số', subTitle: '250,000đ', stats: 25),
          const SizedBox(height: PSizes.spaceBtwItems),
          const PDashboardCard(title: 'Giá trị đơn hàng trung bình', subTitle: '100,000đ', stats: 15),
          const SizedBox(height: PSizes.spaceBtwItems),
          const PDashboardCard(title: 'Tổng đơn hàng', subTitle: '36', stats: 44),
          const SizedBox(height: PSizes.spaceBtwItems),
          const PDashboardCard(title: 'Người dùng', subTitle: '25,035', stats: 2),
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
    )));
  }
}

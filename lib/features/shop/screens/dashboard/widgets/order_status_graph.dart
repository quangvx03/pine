import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/containers/circular_container.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard_controller.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/enums.dart';

class OrderStatusPieChart extends StatelessWidget {
  const OrderStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;
    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trạng thái đơn hàng', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwSections),

          // Graph
          SizedBox(
            height: 400,
            child: PieChart(
              PieChartData(
                sections: controller.orderStatusData.entries.map((entry) {
                  final status = entry.key;
                  final count = entry.value;

                  return PieChartSectionData(
                    radius: 100,
                    title: count.toString(),
                    value: count.toDouble(),
                    color: PHelperFunctions.getOrderStatusColor(status),
                    titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  );

                }).toList(),
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    // Handle touch events here if needed
                  },
                  enabled: true,
                )
              ),
            ),
          ),

          // Show Status and Color Meta
          SizedBox(
            width: double.infinity,
            child: DataTable(
                columns: const [
                  DataColumn(label: Text('Trạng thái')),
                  DataColumn(label: Text('Đơn hàng')),
                  DataColumn(label: Text('Tổng')),
                ],
                rows: controller.orderStatusData.entries.map((entry) {
                  final OrderStatus status = entry.key;
                  final int count  = entry.value;
                  final totalAmount = controller.totalAmounts[status] ?? 0;

                  return DataRow(cells: [
                    DataCell(
                      Row(
                        children: [
                          PCircularContainer(width: 20, height: 20, backgroundColor: PHelperFunctions.getOrderStatusColor(status)),
                          Expanded(child: Text(' ${controller.getDisplayStatusName(status)}')),
                        ],
                      ),
                    ),
                    DataCell(Text(count.toString())),
                    DataCell(Text('${totalAmount.toStringAsFixed(2)}đ')),
                  ]);
                }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

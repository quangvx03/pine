import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/common/widgets/containers/circular_container.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../common/widgets/icons/p_circular_icon.dart';
import '../../../../../../utils/constants/enums.dart';


class OrderStatusPieChart extends StatelessWidget {
  const OrderStatusPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'vi_VN', decimalDigits: 0);

    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PCircularIcon(
                icon: Iconsax.status,
                backgroundColor: Colors.amber.withOpacity(0.1),
                color: Colors.amber,
                size: PSizes.md,
              ),
              const SizedBox(width: PSizes.spaceBtwItems),
              Text('Trạng thái đơn hàng', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwSections),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                    () => controller.orderStatusData.isNotEmpty
                    ? SizedBox(
                  height: 400,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: PDeviceUtils.isTabletScreen(context) ? 80 : 55,
                      startDegreeOffset: 180,
                      sections: controller.orderStatusData.entries.map((entry) {
                        final OrderStatus status = entry.key;
                        final int count = entry.value;

                        return PieChartSectionData(
                          showTitle: true,
                          radius: PDeviceUtils.isTabletScreen(context) ? 80 : 100,
                          title: '$count',
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
                      ),
                    ),
                  ),
                )
                    : const SizedBox(
                  height: 400,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [PLoaderAnimation()]),
                ),
              ),
            ],
          ),

          // Hiển thị trạng thái và tổng tiền
          SizedBox(
            width: double.infinity,
            child: Obx(
                  () => DataTable(
                columns: const [
                  DataColumn(label: Text('Trạng thái')),
                  DataColumn(label: Text('Đơn hàng')),
                  DataColumn(label: Text('Tổng')),
                ],
                rows: controller.orderStatusData.entries.map((entry) {
                  final OrderStatus status = entry.key;
                  final int count = entry.value;
                  final double totalAmount = controller.totalAmounts[status]!;
                  final String displayStatus = controller.getDisplayStatusName(status);

                  return DataRow(cells: [
                    DataCell(
                      Row(
                        children: [
                          PCircularContainer(width: 20, height: 20, backgroundColor: PHelperFunctions.getOrderStatusColor(status)),
                          Expanded(child: Text(' $displayStatus')),
                        ],
                      ),
                    ),
                    DataCell(Text(count.toString())),
                    DataCell(Text(currencyFormatter.format(totalAmount))),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

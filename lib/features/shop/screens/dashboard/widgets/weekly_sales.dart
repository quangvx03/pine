import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard_controller.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';

class PWeeklySalesGraph extends StatelessWidget {
  const PWeeklySalesGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Doanh thu tuần', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwSections),

          // Graph
          SizedBox(
            height: 400,
            child: BarChart(
              BarChartData(
                titlesData: buildFlTitlesData(),
                borderData: FlBorderData(show: true, border: const Border(top: BorderSide.none, right: BorderSide.none)),
                gridData: const FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  horizontalInterval: 200,
                ),
                barGroups: controller.weeklySales
                    .asMap()
                    .entries
                    .map(
                      (entry) => BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        width: 30,
                        toY: entry.value,
                        color: PColors.primary,
                        borderRadius: BorderRadius.circular(PSizes.sm),
                      ),
                    ],
                  ),
                )
                    .toList(),
                groupsSpace: PSizes.spaceBtwItems,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(getTooltipColor: (_) => PColors.secondary),
                  touchCallback: PDeviceUtils.isDesktopScreen(context) ? (barTouchEvent, barTouchResponse) {} : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

FlTitlesData buildFlTitlesData() {
  return FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          // Map index to the desired day of the week
          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

          // Calculate the index and ensure it wraps around for the correct day
          final index = value.toInt() % days.length;

          // Get the day corresponding to the calculated index
          final day = days[index];

          return SideTitleWidget(axisSide: AxisSide.bottom,space: 0, child: Text(day));
        },
      ),
    ),
    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 200, reservedSize: 50)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );

}

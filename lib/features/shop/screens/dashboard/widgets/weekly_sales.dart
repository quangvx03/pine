import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/icons/p_circular_icon.dart';
import 'package:pine_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

class PWeeklySalesGraph extends StatelessWidget {
  const PWeeklySalesGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  PCircularIcon(
                    icon: Iconsax.graph,
                    backgroundColor: Colors.brown.withOpacity(0.1),
                    color: Colors.brown,
                    size: PSizes.md,
                  ),
                  const SizedBox(width: PSizes.spaceBtwItems),
                  Text('Doanh thu', style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
              const _SalesViewSwitcher(),
            ],
          ),

          const SizedBox(height: PSizes.spaceBtwSections),

          /// Biểu đồ
          Obx(() {
            if (controller.isLoading.value) {
              return const SizedBox(
                height: 400,
                child: Center(child: PLoaderAnimation()),
              );
            }

            final sales = controller.weeklySales;
            if (sales.isEmpty) {
              return const SizedBox(
                height: 400,
                child: Center(child: Text('Không có dữ liệu')),
              );
            }

            return SizedBox(
              height: 400,
              child: BarChart(
                BarChartData(
                  titlesData: buildFlTitlesData(sales, controller),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      top: BorderSide.none,
                      right: BorderSide.none,
                    ),
                  ),
                  gridData: const FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    horizontalInterval: 50000,
                  ),
                  groupsSpace: 30,
                  barGroups: sales.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          width: 25,
                          toY: entry.value,
                          color: PColors.primary,
                          borderRadius: BorderRadius.circular(PSizes.sm),
                        ),
                      ],
                    );
                  }).toList(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => PColors.secondary,
                      tooltipPadding: const EdgeInsets.all(8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final value = rod.toY.toStringAsFixed(0);
                        return BarTooltipItem('$valueđ', const TextStyle(color: Colors.white));
                      },
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}


FlTitlesData buildFlTitlesData(List<double> sales, DashboardController controller) {
  final type = controller.salesViewType.value;
  final labels = _generateLabels(type, sales.length, controller);
  final maxY = sales.isNotEmpty ? sales.reduce((a, b) => a > b ? a : b) : 1;
  final interval = ((maxY / 5).ceil()).toDouble();

  return FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          final index = value.toInt();
          if (index < 0 || index >= labels.length) return const SizedBox.shrink();
          return SideTitleWidget(
            axisSide: AxisSide.bottom,
            space: 5,
            child: Text(labels[index], style: const TextStyle(fontSize: 12)),
          );
        },
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: interval,
        reservedSize: 50,
      ),
    ),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );
}

List<String> _generateLabels(String type, int length, DashboardController controller) {
  switch (type) {
    case 'day':
      return List.generate(length, (i) => '${i}h');
    case 'week':
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    case 'month':
    case 'year':
      return List.generate(length, (i) => 'Th${i + 1}');
    case 'range':
      final start = controller.startDate.value;
      if (start == null) return [];
      return List.generate(length.clamp(0, 30), (i) {
        final date = start.add(Duration(days: i));
        return '${date.day}/${date.month}';
      });
    default:
      return List.generate(length, (i) => '$i');
  }
}

class _SalesViewSwitcher extends StatelessWidget {
  const _SalesViewSwitcher();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    final List<Map<String, String>> options = [
      {'label': 'Ngày', 'value': 'day'},
      {'label': 'Tuần', 'value': 'week'},
      {'label': 'Tháng', 'value': 'month'},
      {'label': 'Năm', 'value': 'year'},
      {'label': 'Khoảng thời gian', 'value': 'range'},
    ];

    return Row(
      children: [
        Obx(() => DropdownButton<String>(
          value: controller.salesViewType.value,
          items: options
              .map((opt) => DropdownMenuItem<String>(
            value: opt['value'],
            child: Text(opt['label']!),
          ))
              .toList(),
          onChanged: (value) async {
            if (value == null) return;
            if (value == 'range') {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2023),
                lastDate: DateTime.now(),
                initialDateRange: controller.startDate.value != null
                    ? DateTimeRange(
                  start: controller.startDate.value!,
                  end: controller.endDate.value!,
                )
                    : null,
              );
              if (picked != null) {
                controller.updateDateRange(picked.start, picked.end);
              }
            } else {
              controller.changeSalesViewType(value);
            }
          },
        )),
        const SizedBox(width: 12),
        Obx(() {
          final s = controller.startDate.value;
          final e = controller.endDate.value;
          if (controller.salesViewType.value == 'range' && s != null && e != null) {
            return Text(
              '${s.day}/${s.month} → ${e.day}/${e.month}',
              style: Theme.of(context).textTheme.bodySmall,
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}


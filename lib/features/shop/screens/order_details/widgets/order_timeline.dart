import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/sizes.dart';

class OrderTimeline extends StatelessWidget {
  final OrderStatus status;
  final bool dark;
  final String? orderDateTime;
  final String? deliveryDateTime;

  const OrderTimeline({
    super.key,
    required this.status,
    required this.dark,
    this.orderDateTime,
    this.deliveryDateTime,
  });

  @override
  Widget build(BuildContext context) {
    // Cấu trúc thông tin cho mỗi bước
    final steps = [
      {
        'title': 'Đơn hàng đã đặt',
        'subtitle': 'Đơn hàng của bạn đã được tiếp nhận\n$orderDateTime',
        'icon': Iconsax.receipt_item,
        'color': Colors.orange,
        'status': OrderStatus.pending,
        'isActive': true,
        'isCompleted': true,
      },
      {
        'title': 'Đang xử lý',
        'subtitle': 'Đơn hàng của bạn đang được chuẩn bị',
        'icon': Iconsax.box_1,
        'color': Colors.blue,
        'status': OrderStatus.processing,
        'isActive': _isStatusActiveOrCompleted(status, OrderStatus.processing),
        'isCompleted': _isStatusCompleted(status, OrderStatus.processing),
      },
      {
        'title': 'Đang giao hàng',
        'subtitle': 'Đơn hàng của bạn đang được vận chuyển',
        'icon': Iconsax.truck_fast,
        'color': Colors.purple,
        'status': OrderStatus.shipped,
        'isActive': _isStatusActiveOrCompleted(status, OrderStatus.shipped),
        'isCompleted': _isStatusCompleted(status, OrderStatus.shipped),
      },
      {
        'title': 'Đã giao hàng',
        'subtitle': status == OrderStatus.delivered
            ? 'Đơn hàng của bạn đã được giao thành công${deliveryDateTime != null ? '\n$deliveryDateTime' : ''}'
            : 'Đơn hàng của bạn sẽ được giao',
        'icon': Iconsax.tick_circle,
        'color': Colors.green,
        'status': OrderStatus.delivered,
        'isActive': _isStatusActiveOrCompleted(status, OrderStatus.delivered),
        'isCompleted': _isStatusCompleted(status, OrderStatus.delivered),
      },
    ];

    if (status == OrderStatus.cancelled) {
      final cancelledTime =
          deliveryDateTime != null ? '\n$deliveryDateTime' : '';

      steps.add({
        'title': 'Đã hủy',
        'subtitle': 'Đơn hàng của bạn đã bị hủy$cancelledTime',
        'icon': Iconsax.close_circle,
        'color': Colors.red,
        'status': OrderStatus.cancelled,
        'isActive': true,
        'isCompleted': true,
        'isError': true,
      });
    }

    return Padding(
      padding: const EdgeInsets.all(PSizes.sm),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final step = steps[index];
          final isLast = index == steps.length - 1;
          final isError = step['isError'] == true;

          return _buildTimelineStepItem(
            context: context,
            title: step['title'] as String,
            subtitle: step['subtitle'] as String,
            icon: step['icon'] as IconData,
            color: step['color'] as Color,
            isActive: step['isActive'] as bool,
            isCompleted: step['isCompleted'] as bool,
            isLast: isLast,
            isError: isError,
            dark: dark,
          );
        },
      ),
    );
  }

  // Widget cho mỗi bước trong timeline
  Widget _buildTimelineStepItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isActive,
    required bool isCompleted,
    required bool isLast,
    required bool dark,
    bool isError = false,
  }) {
    final statusColor = isError
        ? Colors.red
        : isCompleted
            ? Colors.green
            : isActive
                ? color
                : Colors.grey.withValues(alpha: 0.5);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần icon và đường kết nối - cố định width và căn chỉnh
          SizedBox(
            width: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon bước
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: statusColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: statusColor,
                      size: 14,
                    ),
                  ),
                ),

                // Đường kết nối với chiều cao cố định và căn giữa
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40, // Chiều cao cố định cho đường kết nối
                    color: isActive
                        ? statusColor
                        : Colors.grey.withValues(alpha: 0.3),
                    // Đặt margin ở giữa để căn đều
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
              ],
            ),
          ),

          const SizedBox(width: PSizes.sm),

          // Nội dung bước với chiều cao cố định
          Expanded(
            child: SizedBox(
              height: isLast ? 80 : 65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề và icon trạng thái
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isActive || isCompleted
                                        ? (isError ? Colors.red : null)
                                        : Colors.grey,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCompleted && !isError)
                        Icon(
                          Iconsax.tick_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Mô tả - giới hạn số dòng
                  Expanded(
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: isActive || isCompleted
                                ? (isError
                                    ? Colors.red.withValues(alpha: 0.7)
                                    : Colors.grey)
                                : Colors.grey.withValues(alpha: 0.7),
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Kiểm tra trạng thái đơn hàng
  bool _isStatusActiveOrCompleted(
      OrderStatus currentStatus, OrderStatus checkStatus) {
    if (currentStatus == OrderStatus.cancelled) {
      return false;
    }
    return currentStatus.index >= checkStatus.index;
  }

  bool _isStatusCompleted(OrderStatus currentStatus, OrderStatus checkStatus) {
    if (currentStatus == OrderStatus.cancelled) {
      return false;
    }
    return currentStatus.index > checkStatus.index;
  }
}

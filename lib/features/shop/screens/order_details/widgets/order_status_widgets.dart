import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/features/shop/models/order_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/sizes.dart';

class OrderStatusCard extends StatelessWidget {
  final OrderModel order;
  final bool dark;

  const OrderStatusCard({
    super.key,
    required this.order,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = getStatusInfo(order.status);

    return PRoundedContainer(
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: PSizes.xs, horizontal: PSizes.sm),
        decoration: BoxDecoration(
          color: statusInfo.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(PSizes.sm),
              decoration: BoxDecoration(
                color: statusInfo.color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusInfo.icon,
                color: statusInfo.color,
                size: 22,
              ),
            ),
            const SizedBox(width: PSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusInfo.text,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: statusInfo.color,
                        ),
                  ),
                  const SizedBox(height: PSizes.xs),
                  Text(
                    statusInfo.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryAddress extends StatelessWidget {
  final OrderModel order;
  final bool dark;

  const DeliveryAddress({
    super.key,
    required this.order,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    final address = order.address!;
    final textColor = dark ? Colors.white70 : Colors.grey.shade700;

    return Padding(
      padding: const EdgeInsets.all(PSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên người nhận
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  'Người nhận:',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: textColor,
                      ),
                ),
              ),
              Expanded(
                child: Text(
                  address.name,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : PColors.dark,
                      ),
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),

          // Thanh ngang ngăn cách
          Container(
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            height: 1,
            color: dark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),

          // Số điện thoại
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  'Điện thoại:',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: textColor,
                      ),
                ),
              ),
              Expanded(
                child: Text(
                  address.phoneNumber,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          // Thanh ngang ngăn cách
          Container(
            margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
            height: 1,
            color: dark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),

          // Địa chỉ
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  'Địa chỉ:',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: textColor,
                      ),
                ),
              ),
              Expanded(
                child: Text(
                  '${address.street}, ${address.ward}, ${address.city}, ${address.province}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Class lưu trữ thông tin hiển thị theo trạng thái
class StatusInfo {
  final String text;
  final String description;
  final Color color;
  final IconData icon;

  StatusInfo({
    required this.text,
    required this.description,
    required this.color,
    required this.icon,
  });
}

// Lấy thông tin hiển thị cho trạng thái
StatusInfo getStatusInfo(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return StatusInfo(
        text: 'Chờ xử lý',
        description: 'Đơn hàng của bạn đã được xác nhận và đang chờ xử lý',
        color: Colors.orange,
        icon: Iconsax.timer_1,
      );
    case OrderStatus.processing:
      return StatusInfo(
        text: 'Đang xử lý',
        description: 'Đơn hàng của bạn đang được chuẩn bị',
        color: Colors.blue,
        icon: Iconsax.box_1,
      );
    case OrderStatus.shipped:
      return StatusInfo(
        text: 'Đang giao hàng',
        description: 'Đơn hàng của bạn đang được vận chuyển',
        color: Colors.purple,
        icon: Iconsax.truck_fast,
      );
    case OrderStatus.delivered:
      return StatusInfo(
        text: 'Đã giao hàng',
        description: 'Đơn hàng của bạn đã được giao thành công',
        color: Colors.green,
        icon: Iconsax.tick_circle,
      );
    case OrderStatus.cancelled:
      return StatusInfo(
        text: 'Đã hủy',
        description: 'Đơn hàng của bạn đã bị hủy',
        color: Colors.red,
        icon: Iconsax.close_circle,
      );
  }
}

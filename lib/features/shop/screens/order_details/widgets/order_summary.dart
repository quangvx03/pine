import 'package:flutter/material.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double total;
  final double discount;
  final String? couponCode;

  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
    this.discount = 0,
    this.couponCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tạm tính
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tạm tính', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              PHelperFunctions.formatCurrency(subtotal),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: PSizes.sm),

        // Phí vận chuyển
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Phí vận chuyển',
                style: Theme.of(context).textTheme.bodyMedium),
            Text(
              PHelperFunctions.formatCurrency(shippingFee),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),

        // Hiển thị phần mã giảm giá nếu có
        if (discount > 0) ...[
          const SizedBox(height: PSizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Mã giảm giá',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (couponCode != null && couponCode!.isNotEmpty) ...[
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: '($couponCode)',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: PColors.primary,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                '- ${PHelperFunctions.formatCurrency(discount)}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: PColors.favorite,
                    ),
              ),
            ],
          ),
        ],

        // Đường phân cách
        Container(
          margin: const EdgeInsets.symmetric(vertical: PSizes.sm),
          height: 1,
          color: Colors.grey.shade200,
        ),

        // Tổng thanh toán
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tổng thanh toán',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              PHelperFunctions.formatCurrency(total),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: PColors.primary,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

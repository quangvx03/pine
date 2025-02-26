import 'package:flutter/material.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/utils/constants/sizes.dart';

class PBillingAmountSection extends StatelessWidget {
  const PBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PSectionHeading(
          title: 'Chi tiết thanh toán',
          showActionButton: false,
        ),
        const SizedBox(height: PSizes.spaceBtwItems / 2),

        /// Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tạm tính', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '2,500,000₫',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems / 2),

        /// Shipping fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Phí vận chuyển',
                style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '30,000₫',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems / 2),

        /// Coupon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Mã giảm giá', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '50,000₫',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems / 2),

        /// Order total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tổng đơn hàng',
                style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '2,480,000₫',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems / 2),
      ],
    );
  }
}

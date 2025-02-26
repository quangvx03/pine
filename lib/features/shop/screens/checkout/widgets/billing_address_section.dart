import 'package:flutter/material.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/utils/constants/sizes.dart';

class PBillingAddressSection extends StatelessWidget {
  const PBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PSectionHeading(
            title: 'Địa chỉ nhận hàng',
            buttonTitle: 'Thay đổi',
            onPressed: () {}),
        Text('Nguyễn Văn A', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: PSizes.spaceBtwItems / 2),
        Row(
          children: [
            const Icon(Icons.phone, color: Colors.grey, size: 16),
            const SizedBox(width: PSizes.spaceBtwItems),
            Text('0987654321', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems / 2),
        Row(
          children: [
            const Icon(Icons.location_city_rounded, color: Colors.grey, size: 16),
            const SizedBox(width: PSizes.spaceBtwItems),
            Expanded(
                child: Text(
                    '1 Phù Đổng Thiên Vương, Phường 7, Đà Lạt, Lâm Đồng',
                    style: Theme.of(context).textTheme.bodyMedium,
                    softWrap: true))
          ],
        )
      ],
    );
  }
}

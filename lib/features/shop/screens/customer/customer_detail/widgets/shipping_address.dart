import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ShippingAddress extends StatelessWidget {
  const ShippingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Địa chỉ giao hàng', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: PSizes.spaceBtwSections),

          // Meta Data
          Row(
            children: [
              const SizedBox(width: 120, child: Text('Tên')),
              const Text(':'),
              const SizedBox(width: PSizes.spaceBtwItems / 2),
              Expanded(child: Text('User1', style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwItems),
          Row(
            children: [
              const SizedBox(width: 120, child: Text('Thành phố')),
              const Text(':'),
              const SizedBox(width: PSizes.spaceBtwItems / 2),
              Expanded(child: Text('Đà Lạt', style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwItems),
          Row(
            children: [
              const SizedBox(width: 120, child: Text('Số điện thoại')),
              const Text(':'),
              const SizedBox(width: PSizes.spaceBtwItems / 2),
              Expanded(child: Text('+84271830291', style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwItems),
          Row(
            children: [
              const SizedBox(width: 120, child: Text('Địa chỉ')),
              const Text(':'),
              const SizedBox(width: PSizes.spaceBtwItems / 2),
              Expanded(child: Text('1 Phù Đổng Thiên Vương', style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
        ],
      ),
    );
  }
}

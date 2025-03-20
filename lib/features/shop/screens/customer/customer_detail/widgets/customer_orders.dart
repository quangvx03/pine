import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/customer_data_table.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tất cả đơn hàng', style: Theme.of(context).textTheme.headlineMedium),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Tổng tiền '),
                    TextSpan(text: '520,000đ', style: Theme.of(context).textTheme.bodyLarge!.apply(color: PColors.primary)),
                    TextSpan(text: ' cho ${5} Đơn hàng', style: Theme.of(context).textTheme.bodyLarge),
                  ]
                )
              )
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwItems),
          TextFormField(
            onChanged: (query) {},
            decoration: const InputDecoration(hintText: 'Tìm kiếm đơn hàng', prefixIcon: Icon(Iconsax.search_normal)),
          ),
          const SizedBox(height: PSizes.spaceBtwSections),
          const CustomerOrderTable(),

        ],
      ),
    );
  }
}

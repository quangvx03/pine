import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../layouts/grid_layout.dart';
import '../product_cards/product_card_vertical.dart';

class PSortableProducts extends StatelessWidget {
  const PSortableProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Dropdown
        DropdownButtonFormField(
            decoration:
            const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
            onChanged: (value) {},
            items: [
              'Tên',
              'Giá cao',
              'Giá thấp',
              'Giảm giá',
              'Mới nhất',
              'Phổ biến'
            ]
                .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                .toList()),
        const SizedBox(height: PSizes.spaceBtwSections,),

        /// Products
        PGridLayout(itemCount: 6, itemBuilder: (_, index) => const PProductCardVertical()),
      ],
    );
  }
}
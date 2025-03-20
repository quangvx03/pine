import 'package:flutter/material.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ProductTypeWidget extends StatelessWidget {
  const ProductTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Loại', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: PSizes.spaceBtwItems),
        // Radio button for Single Product Type
        RadioMenuButton(
          value: ProductType.single,
          groupValue: ProductType.single,
          onChanged: (value) {},
          child: const Text('Lẻ'),
        ),
        // Radio button for Variable Product Type
        RadioMenuButton(
          value: ProductType.variable,
          groupValue: ProductType.single,
          onChanged: (value) {},
          child: const Text('Thay đổi'),
        ),
      ],
    );
  }
}

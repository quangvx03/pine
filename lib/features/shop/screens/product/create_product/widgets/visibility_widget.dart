import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ProductVisibilityWidget extends StatelessWidget {
  const ProductVisibilityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visibility Header
          Text('Khả năng hiển thị', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwItems),

          // Radio buttons for product visibility
          Column(
            children: [
              _buildVisibilityRadioButton(ProductVisibility.published, 'Công khai'),
              _buildVisibilityRadioButton(ProductVisibility.hidden, 'Ẩn'),
            ],
          )
        ],
      ),
    );
  }

  // Helper method to build a radio button for product visibility
  Widget _buildVisibilityRadioButton(ProductVisibility value, String label) {
    return RadioMenuButton<ProductVisibility>(
      value: value,
      groupValue: ProductVisibility.published,
      onChanged: (selection) {},
      child: Text(label),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ProductBottomNavigationButtons extends StatelessWidget {
  const ProductBottomNavigationButtons({super.key, required this.product});
  
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Discard button
          OutlinedButton(
              onPressed: (){

              },
              child: const Text('Xóa')),
          const SizedBox(width: PSizes.spaceBtwItems / 2),

          // Save Changes button
          SizedBox(
              width: 160,
              child: ElevatedButton(
                  onPressed: () => EditProductController.instance.editProduct(product),
                  child: const Text('Lưu thay đổi'))),
        ],
      ),
    );
  }
}

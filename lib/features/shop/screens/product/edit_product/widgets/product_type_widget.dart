import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ProductTypeWidget extends StatelessWidget {
  const ProductTypeWidget({super.key, required this.product});

  final  ProductModel product;

  @override
  Widget build(BuildContext context) {
    final editController = EditProductController.instance;

    return Obx(
      () => Row(
        children: [
          Text('Loại', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: PSizes.spaceBtwItems),
          // Radio button for Single Product Type
          RadioMenuButton(
            value: ProductType.single,
            groupValue: editController.productType.value,
            onChanged: (value) {
              editController.productType.value = value ?? ProductType.single;
            },
            child: const Text('Một loại'),
          ),
          // Radio button for Variable Product Type
          RadioMenuButton(
            value: ProductType.variable,
            groupValue: editController.productType.value,
            onChanged: (value) {
              editController.productType.value = value ?? ProductType.single;
            },
            child: const Text('Nhiều loại'),
          ),
        ],
      ),
    );
  }
}

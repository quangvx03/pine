import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/shop/controllers/all_products_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';

import '../../../../utils/constants/sizes.dart';
import '../../layouts/grid_layout.dart';
import '../product_cards/product_card_vertical.dart';

class PSortableProducts extends StatelessWidget {
  const PSortableProducts({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    controller.assignProducts(products);
    return Column(
      children: [
        /// Dropdown
        DropdownButtonFormField(
            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
            value: controller.selectedSortOption.value,
            onChanged: (value) {
              controller.sortProducts(value!);
            },
            items: [
              'Tên',
              'Giá cao',
              'Giá thấp',
              'Giảm giá',
              'Mới nhất',
            ]
                .map((option) =>
                    DropdownMenuItem(value: option, child: Text(option)))
                .toList()),
        const SizedBox(
          height: PSizes.spaceBtwSections,
        ),

        /// Products
        Obx(
          () => PGridLayout(
              itemCount: controller.products.length,
              itemBuilder: (_, index) =>
                  PProductCardVertical(product: controller.products[index])),
        ),
      ],
    );
  }
}

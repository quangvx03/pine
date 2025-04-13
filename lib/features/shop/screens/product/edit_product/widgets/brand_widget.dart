import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:pine_admin_panel/features/shop/controllers/brand/brand_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:pine_admin_panel/features/shop/models/brand_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ProductBrand extends StatelessWidget {
  const ProductBrand({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditProductController());
    final brandController = Get.put(BrandController());

    if (brandController.allItems.isEmpty) {
      brandController.fetchItems();
    }

    if (editController.selectedBrand.value == null && product.brand != null) {
      editController.selectedBrand.value = product.brand;
      editController.brandTextField.text = product.brand!.name;
    }

    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thương hiệu', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwItems),

          Obx(() {
            if (brandController.isLoading.value) {
              return const PShimmerEffect(width: double.infinity, height: 50);
            }

            return TypeAheadField<BrandModel>(
              builder: (context, ctr, focusNode) {
                if (editController.brandTextField != ctr) {
                  editController.brandTextField = ctr;
                  editController.brandTextField.text = editController.selectedBrand.value?.name ?? '';
                }

                return TextFormField(
                  controller: ctr,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Chọn thương hiệu',
                    suffixIcon: Icon(Iconsax.box),
                  ),
                );
              },
              suggestionsCallback: (pattern) {
                return brandController.allItems
                    .where((brand) => brand.name.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, BrandModel suggestion) {
                return ListTile(title: Text(suggestion.name));
              },
              onSelected: (BrandModel suggestion) {
                editController.selectedBrand.value = suggestion;
                editController.brandTextField.text = suggestion.name;
              },
            );
          }),
        ],
      ),
    );
  }
}


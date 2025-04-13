import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:pine_admin_panel/features/shop/controllers/brand/brand_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:pine_admin_panel/features/shop/models/brand_model.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ProductBrand extends StatelessWidget {
  const ProductBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateProductController());
    final brandController = Get.put(BrandController());

    if (brandController.allItems.isEmpty) {
      brandController.fetchItems();
    }

    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand label
          Text('Thương hiệu', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwItems),

          // TypeAheadField for brand selection
          Obx(
            () => brandController.isLoading.value
              ? const PShimmerEffect(width: double.infinity, height: 50)
              : TypeAheadField(
              builder: (context, ctr, focusNode) {
                return TextFormField(
                  focusNode: focusNode,
                  controller: controller.brandTextField = ctr,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Chọn thương hiệu',
                    suffixIcon: Icon(Iconsax.box),
                  ),
                );
              },
                suggestionsCallback: (pattern) {
                  // Return filtered brand suggestions based on the search pattern
                  return brandController.allItems.where((brand) => brand.name.contains(pattern)).toList();
                },
                itemBuilder: (context, suggestion) {
                return ListTile(title: Text(suggestion.name));
                },
                onSelected: (suggestion) {
                controller.selectedBrand.value = suggestion;
                controller.brandTextField.text = suggestion.name;
                },
            ),
          )
        ],
      ),
    );
  }
}

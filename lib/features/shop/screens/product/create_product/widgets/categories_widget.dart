import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:pine_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:pine_admin_panel/features/shop/models/category_model.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../controllers/product/create_product_controller.dart';



class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesController = Get.put(CategoryController());

    if (categoriesController.allItems.isEmpty) {
      categoriesController.fetchItems();
    }

    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories label
          Text('Danh mục', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwItems),

          // MultiSelectDialogField for selecting categories
          Obx(
            () => categoriesController.isLoading.value
              ? const PShimmerEffect(width: double.infinity, height: 50)
              : MultiSelectDialogField(
              buttonText: const Text('Chọn danh mục'),
              title: const Text('Danh mục'),
              items: categoriesController.allItems.map((category) => MultiSelectItem(category, category.name)).toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                CreateProductController.instance.selectedCategories.assignAll(values);
              },
            ),
          )
        ],
      ),
    );
  }
}

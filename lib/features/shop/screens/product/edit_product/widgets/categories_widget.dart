import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:pine_admin_panel/features/shop/models/category_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/helpers/cloud_helper_functions.dart';


class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final productController = EditProductController.instance;

    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories label
          Text('Danh mục', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwItems),

          // MultiSelectDialogField for selecting categories
          FutureBuilder(
            future: productController.loadSelectedCategories(product.id),
          builder: (context, snapshot) {
              final widget = PCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
              if (widget != null) return widget;

            return MultiSelectDialogField(
              buttonText: const Text('Chọn danh mục'),
              title: const Text('Danh mục'),
              initialValue: List<CategoryModel>.from(productController.selectedCategories),
              items: CategoryController.instance.allItems.map((category) => MultiSelectItem(category, category.name)).toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                productController.selectedCategories.assignAll(values);
              },
            );
          },

          )
        ],
      ),
    );
  }
}

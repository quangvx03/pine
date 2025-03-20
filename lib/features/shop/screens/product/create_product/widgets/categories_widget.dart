import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/models/category_model.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories label
          Text('Danh mục', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwItems),

          // MultiSelectDialogField for selecting categories
          MultiSelectDialogField(
            buttonText: const Text('Chọn danh mục'),
            title: const Text('Danh mục'),
            items: [
              MultiSelectItem(CategoryModel(id: 'id', name: 'Đồ uống', image: 'Hình ảnh'), 'Đồ uống'),
              MultiSelectItem(CategoryModel(id: 'id', name: 'Ăn vặt', image: 'Hình ảnh'), 'Ăn vặt'),
            ],
            listType: MultiSelectListType.CHIP,
            onConfirm: (values) {},
          )
        ],
      ),
    );
  }
}

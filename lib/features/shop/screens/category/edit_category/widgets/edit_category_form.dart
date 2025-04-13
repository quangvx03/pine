import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../../utils/constants/enums.dart';
import '../../../../../../../utils/constants/image_strings.dart';
import '../../../../controllers/category/edit_category_controller.dart';
import '../../../../models/category_model.dart';


class EditCategoryForm extends StatelessWidget {
  const EditCategoryForm({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditCategoryController());
    Future.microtask(() => editController.init(category));
    final categoryController = Get.put(CategoryController());
    return PRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Form(
        key: editController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: PSizes.sm),
            Text('Cập nhật danh mục', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: PSizes.spaceBtwSections),

            // Name Text Field
            TextFormField(
              controller: editController.name,
              validator: (value) => PValidator.validateEmptyText('Tên', value),
              decoration: const InputDecoration(labelText: 'Tên danh mục', prefixIcon: Icon(Iconsax.category)),
            ),

            const SizedBox(height: PSizes.spaceBtwInputFields),

            Obx(
                  () => DropdownButtonFormField<CategoryModel>(
                decoration: const InputDecoration(
                  hintText: 'Danh mục cha',
                  labelText: 'Danh mục cha',
                  prefixIcon: Icon(Iconsax.bezier),
                ),
                onChanged: (newValue) => editController.selectedParent.value = newValue!,

                value: editController.selectedParent.value.id.isNotEmpty ? editController.selectedParent.value : null,

                items: [
                  DropdownMenuItem(
                    value: CategoryModel(id: "", name: "Không có", image: ""),
                    child: const Text("Không có"),
                  ),
                  ...categoryController.allItems.map(
                        (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item.name),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: PSizes.spaceBtwInputFields * 2),
            Obx(
              () => PImageUploader(
                width: 80,
                height: 80,
                image: editController.imageURL.value.isNotEmpty ? editController.imageURL.value : PImages.defaultImage,
                imageType: editController.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                onIconButtonPressed: () => editController.pickImage(),
              ),
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields),

            Obx(
              () => CheckboxMenuButton(
                value: editController.isFeatured.value,
                onChanged: (value) => editController.isFeatured.value = value ?? false,
                child: const Text('Nổi bật'),
              ),
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields * 2),
          SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => editController.updateCategory(category), child: const Text('Cập nhật')),
              ),
            const SizedBox(height: PSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}

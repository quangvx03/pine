import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:pine_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:pine_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/category/create_category_controller.dart';


class CreateCategoryForm extends StatelessWidget {
  const CreateCategoryForm({super.key});


  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateCategoryController());
    final categoryController = Get.put(CategoryController());

    return PRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Form(
        key: createController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              const SizedBox(height: PSizes.sm),
              Text('Tạo danh mục', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Name Text Field
              TextFormField(
                controller: createController.name,
                validator: (value) => PValidator.validateEmptyText('Tên', value),
                decoration: const InputDecoration(labelText: 'Tên danh mục', prefixIcon: Icon(Iconsax.category)),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields),

              Obx(
                () => categoryController.isLoading.value ? 
                    const PShimmerEffect(width: double.infinity, height: 55)
                : DropdownButtonFormField(
                  decoration:
                    const InputDecoration(hintText: 'Danh mục cha', labelText: 'Danh mục cha', prefixIcon: Icon(Iconsax.bezier)),
                    onChanged: (newValue) => createController.selectedParent.value = newValue!,
                  items: categoryController.allItems.map((item) => DropdownMenuItem(
                    value: item,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(item.name)]),
                  )).toList()
                ),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields * 2),
              Obx(
                () => PImageUploader(
                  width: 80,
                    height: 80,
                    image: createController.imageURL.value.isNotEmpty ? createController.imageURL.value : PImages.defaultImage,
                    imageType: createController.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                  onIconButtonPressed: () => createController.pickImage(),
                ),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields),

              Obx(
                () => CheckboxMenuButton(
                  value: createController.isFeatured.value,
                  onChanged: (value) => createController.isFeatured.value = value ?? false,
                  child: const Text('Nổi bật'),
                ),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields * 2),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => createController.createCategory(), child: const Text('Tạo')),
              ),

              const SizedBox(height: PSizes.spaceBtwInputFields * 2),
            ],
          )
      ),
    );
  }
}

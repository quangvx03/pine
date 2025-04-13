import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/chips/rounded_choice_chips.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:pine_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/brand/create_brand_controller.dart';


class CreateBrandForm extends StatelessWidget {
  const CreateBrandForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateBrandController());
    return PRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Form(
        key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              const SizedBox(height: PSizes.sm),
              Text('Thêm thương hiệu', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Name Text Field
              TextFormField(
                controller: controller.name,
                validator: (value) => PValidator.validateEmptyText('Tên', value),
                decoration: const InputDecoration(labelText: 'Tên thương hiệu', prefixIcon: Icon(Iconsax.box)),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields),
              
              // Categories
              Text('Chọn danh mục', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: PSizes.spaceBtwInputFields / 2),
              Obx(
                () => Wrap(
                  spacing: PSizes.sm,
                  children: CategoryController.instance.allItems
                  .map((category) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: PSizes.sm),
                      child: PChoiceChip(
                          text: category.name,
                          selected: controller.selectedCategories.contains(category),
                          onSelected: (values) => controller.toggleSelection(category)),
                    ),
                  ).toList(),

                ),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields * 2),

              Obx(
                () => PImageUploader(
                  width: 80,
                  height: 80,
                  image: controller.imageURL.value.isNotEmpty ? controller.imageURL.value : PImages.defaultImage,
                  imageType: controller.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                  onIconButtonPressed: () => controller.pickImage(),
                ),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields),

              Obx(
                () => CheckboxMenuButton(
                  value: controller.isFeatured.value,
                  onChanged: (value) => controller.isFeatured.value = value ?? false,
                  child: const Text('Nổi bật'),
                ),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields * 2),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => controller.createBrand(), child: const Text('Thêm')),
              ),

              const SizedBox(height: PSizes.spaceBtwInputFields * 2),
            ],
          )
      ),
    );
  }
}

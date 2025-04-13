import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../../common/widgets/chips/rounded_choice_chips.dart';
import '../../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../../utils/constants/enums.dart';
import '../../../../../../../utils/constants/image_strings.dart';
import '../../../../controllers/brand/edit_brand_controller.dart';
import '../../../../models/brand_model.dart';


class EditBrandForm extends StatelessWidget {
  const EditBrandForm({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBrandController());
    Future.microtask(() => controller.init(brand));
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
              Text('Cập nhật thương hiệu', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Name Text Field
              TextFormField(
                controller: controller.name,
                validator: (value) => PValidator.validateEmptyText('Tên', value),
                decoration: const InputDecoration(labelText: 'Tên thương hiệu', prefixIcon: Icon(Iconsax.category)),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields),

              // Categories
              Text('Chọn danh mục', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: PSizes.spaceBtwInputFields / 2),
              Obx(
                () => Wrap(
                  spacing: PSizes.sm,
                  children: CategoryController.instance.allItems
                  .map(
                      (element) => Padding(
                      padding: const EdgeInsets.only(bottom: PSizes.sm),
                      child: PChoiceChip(
                          text: element.name, 
                          selected: controller.selectedCategories.contains(element), 
                          onSelected: (values) => controller.toggleSelection(element)),
                    ),
                  )
                    .toList()
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
                child: ElevatedButton(onPressed: () => controller.updateBrand(brand), child: const Text('Cập nhật')),
              ),


              const SizedBox(height: PSizes.spaceBtwInputFields * 2),
            ],
          )
      ),
    );
  }
}

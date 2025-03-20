import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../models/category_model.dart';

class EditCategoryForm extends StatelessWidget {
  const EditCategoryForm({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(PSizes.defaultSpace),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            const SizedBox(height: PSizes.sm),
            Text('Cập nhật danh mục', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: PSizes.spaceBtwSections),

            // Name Text Field
            TextFormField(
              validator: (value) => PValidator.validateEmptyText('Tên', value),
              decoration: const InputDecoration(labelText: 'Tên danh mục', prefixIcon: Icon(Iconsax.category)),
            ),

            const SizedBox(height: PSizes.spaceBtwInputFields),

            DropdownButtonFormField(
              decoration: const InputDecoration(
                hintText: 'Danh mục cha',
                labelText: 'Danh mục cha',
                prefixIcon: Icon(Iconsax.bezier),
              ),
              onChanged: (newValue) {},
              items: const [
                DropdownMenuItem(
                  value: '',
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Text('item.name')]),
                )
              ],
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields * 2),
            PImageUploader(
              width: 80,
              height: 80,
              image: PImages.defaultImage,
              imageType: ImageType.asset,
              onIconButtonPressed: () {},
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields),

            CheckboxMenuButton(
              value: true,
              onChanged: (value) {},
              child: const Text('Nổi bật'),
            ),
            const SizedBox(height: PSizes.spaceBtwInputFields * 2),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {}, child: const Text('Cập nhật')),
            ),

            const SizedBox(height: PSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}

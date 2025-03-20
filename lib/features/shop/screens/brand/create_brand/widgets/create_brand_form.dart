import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/chips/rounded_choice_chips.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../utils/constants/sizes.dart';

class CreateBrandForm extends StatelessWidget {
  const CreateBrandForm({super.key});

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
              Text('Thêm thương hiệu', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Name Text Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tên thương hiệu', prefixIcon: Icon(Iconsax.box)),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields),
              
              // Categories
              Text('Chọn danh mục', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: PSizes.spaceBtwInputFields / 2),
              Wrap(
                spacing: PSizes.sm,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: PSizes.sm),
                    child: PChoiceChip(text: 'Đồ uống', selected: false, onSelected: (values) {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: PSizes.sm),
                    child: PChoiceChip(text: 'Đông lạnh', selected: false, onSelected: (values) {}),
                  ),
                ],
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields * 2),

              PImageUploader(
                width: 80,
                height: 80,
                image: PImages.defaultImage,
                imageType: ImageType.asset,
                onIconButtonPressed: (){},
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields),

              CheckboxMenuButton(
                value: true,
                onChanged: (value){},
                child: const Text('Nổi bật'),
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields * 2),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){}, child: const Text('Thêm')),
              ),


              const SizedBox(height: PSizes.spaceBtwInputFields * 2),
            ],
          )
      ),
    );
  }
}

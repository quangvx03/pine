import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';

import '../../../../../../common/widgets/chips/rounded_choice_chips.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class CreateBannerForm extends StatelessWidget {
  const CreateBannerForm({super.key});

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
              Text('Thêm banner', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Image Uploader & Featured Checkbox
              Column(
                children: [
                  GestureDetector(
                    child: const PRoundedImage(
                      width: 400,
                        height: 200,
                        backgroundColor: PColors.primaryBackground,
                        image: PImages.defaultImage,
                        imageType: ImageType.asset,
                    ),
                  ),
                  const SizedBox(height: PSizes.spaceBtwItems),
                  TextButton(onPressed: () {}, child: const Text('Chọn ảnh')),
                ],
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields),
              
              Text('Làm cho Banner của bạn hoạt động hoặc không hoạt động', style: Theme.of(context).textTheme.bodyMedium),
              CheckboxMenuButton(value: true, onChanged: (value) {}, child: const Text('Hoạt động')),
              const SizedBox(height: PSizes.spaceBtwInputFields),

              // Dropdown Menu Screens
              DropdownButton<String>(value: 'search', onChanged: (String? newValue) {}, items: const [
                DropdownMenuItem<String>(value: 'home', child: Text('Trang chủ')),
                DropdownMenuItem<String>(value: 'search', child: Text('Tìm kiếm')),
              ]),
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

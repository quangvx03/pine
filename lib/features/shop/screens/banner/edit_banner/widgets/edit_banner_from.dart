import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/controllers/banner/edit_banner_controller.dart';
import 'package:pine_admin_panel/features/shop/models/banner_model.dart';

import '../../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../../routes/app_screens.dart';
import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/enums.dart';
import '../../../../../../../utils/constants/image_strings.dart';
import '../../../../../../../utils/constants/sizes.dart';


class EditBannerForm extends StatelessWidget {
  const EditBannerForm({super.key, required this.banner});

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBannerController());
    Future.microtask(() => controller.init(banner));
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
              Text('Cập nhật banner', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Image Uploader & Featured Checkbox
              Column(
                children: [
                  Obx(
                    () => PRoundedImage(
                      width: 400,
                      height: 200,
                      backgroundColor: PColors.primaryBackground,
                      image: controller.imageURL.value.isNotEmpty ? controller.imageURL.value : PImages.defaultImage,
                      imageType: controller.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                    ),
                  ),
                  const SizedBox(height: PSizes.spaceBtwItems),
                  TextButton(onPressed: () => controller.pickImage(), child: const Text('Chọn ảnh')),
                ],
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields),

              Text('Làm cho Banner của bạn hoạt động hoặc không hoạt động', style: Theme.of(context).textTheme.bodyMedium),
              Obx(
                      () => CheckboxMenuButton(
                          value: controller.isActive.value,
                          onChanged: (value) => controller.isActive.value = value ?? false,
                          child: const Text('Hoạt động'))),
              const SizedBox(height: PSizes.spaceBtwInputFields),

              // Dropdown Menu Screens
              Obx(
                      () {
                    return DropdownButton<String>(
                      value: controller.targetScreen.value,
                      onChanged: (String? newValue) => controller.targetScreen.value = newValue!,
                      items: AppScreens.allAppScreenItems.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                    );
                  }
              ),
              const SizedBox(height: PSizes.spaceBtwInputFields * 2),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => controller.updateBanner(banner), child: const Text('Cập nhật')),
              ),


              const SizedBox(height: PSizes.spaceBtwInputFields * 2),
            ],
          )
      ),
    );
  }
}

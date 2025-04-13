import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:pine_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class ImageAndMeta extends StatelessWidget {
  const ImageAndMeta({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return PRoundedContainer(
      padding: const EdgeInsets.symmetric(vertical: PSizes.lg, horizontal: PSizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              // User Image
              Obx(
                () => PImageUploader(
                  right: 10,
                    bottom: 20,
                    left: null,
                    width: 200,
                    height: 200,
                    circular: true,
                    icon: Iconsax.camera,
                    //loading: controller.loading.value,
                    onIconButtonPressed: () => controller.updateProfilePicture(),
                    imageType: controller.user.value.profilePicture.isNotEmpty ? ImageType.network : ImageType.asset,
                  image: controller.user.value.profilePicture.isNotEmpty ? controller.user.value.profilePicture : PImages.user,
                ),
              ),
              const SizedBox(height: PSizes.spaceBtwItems),
              Obx(() => Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineLarge)),
              Obx(
                () => Text(controller.user.value.email)),
                const SizedBox(height: PSizes.spaceBtwSections),

              ],
          )
        ],
      ),
    );
  }
}

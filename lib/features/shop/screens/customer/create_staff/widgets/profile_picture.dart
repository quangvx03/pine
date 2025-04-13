import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/controllers/customer/create_staff_controller.dart';

import '../../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../../common/widgets/images/p_rounded_image.dart';
import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/enums.dart';
import '../../../../../../../utils/constants/image_strings.dart';
import '../../../../../../../utils/constants/sizes.dart';


class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateStaffController());

    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Thumbnail Text
          Text('Ảnh đại diện', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwItems),

          // Container for Product Thumbnail
          PRoundedContainer(
            height: 300,
            backgroundColor: PColors.primaryBackground,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thumbnail Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Obx(
                                () => GestureDetector(
                                  child: PRoundedImage(
                                  width: 220,
                                  height: 220,
                                  image: controller.profilePicture.value.isNotEmpty ? controller.profilePicture.value : PImages.defaultImage,
                                  imageType: controller.profilePicture.value.isNotEmpty ? ImageType.network : ImageType.asset),
                                )
                        ),
                      )
                    ],
                  ),

                  // Add Thumbnail Button
                  SizedBox(
                      width: 200,
                      child: OutlinedButton(
                          onPressed: () => controller.pickImage(),
                          child: const Text('Cập nhật ảnh đại diện'))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

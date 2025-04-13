import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/personalization/models/user_model.dart';

import '../../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../../common/widgets/images/p_rounded_image.dart';
import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/enums.dart';
import '../../../../../../../utils/constants/image_strings.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/customer/edit_staff_controller.dart';

class EditProfilePicture extends StatelessWidget {
  const EditProfilePicture({super.key, required this.staff});

  final UserModel staff;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditStaffController());

    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Text
          Text('Ảnh đại diện', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: PSizes.spaceBtwItems),

          // Container for Profile Picture
          PRoundedContainer(
            height: 300,
            backgroundColor: PColors.primaryBackground,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Obx(
                              () => GestureDetector(
                            onTap: () => controller.pickImage(),  // Pick image when tapped
                            child: PRoundedImage(
                              width: 220,
                              height: 220,
                              image: controller.profilePicture.value.isNotEmpty
                                  ? controller.profilePicture.value
                                  : PImages.defaultImage,
                              imageType: controller.profilePicture.value.isNotEmpty
                                  ? ImageType.network
                                  : ImageType.asset,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    width: 200,
                    child: OutlinedButton(
                      onPressed: () => controller.pickImage(),
                      child: const Text('Thêm ảnh đại diện'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

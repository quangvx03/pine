import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/personalization/controllers/user_controller.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../images/circular_image.dart';
import '../shimmers/shimmer.dart';

class PUserProfileTile extends StatelessWidget {
  const PUserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return ListTile(
      leading: Obx(() {
        final networkImage = controller.user.value.profilePicture;
        final image = networkImage.isNotEmpty ? networkImage : PImages.user;
        return controller.imageUploading.value
            ? const PShimmerEffect(
                width: 50,
                height: 50,
                radius: 100,
              )
            : PCircularImage(
                image: image,
                width: 50,
                height: 50,
                padding: 0,
                isNetworkImage: networkImage.isNotEmpty);
      }),
      title: Obx(
        () => Text(controller.user.value.fullName,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: PColors.white)),
      ),
      subtitle: Obx(
        () => Text(
          controller.user.value.email,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .apply(color: PColors.white),
        ),
      ),
      trailing: IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Iconsax.edit,
            color: PColors.white,
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:pine_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

import '../../../../utils/constants/colors.dart';

class PHeader extends StatelessWidget implements PreferredSizeWidget {
  const PHeader({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Container(
      decoration: const BoxDecoration(
        color: PColors.white,
        border: Border(bottom: BorderSide(color: PColors.grey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: PSizes.md, vertical: PSizes.sm),
      child: AppBar(
        /// Mobile Menu
        leading: !PDeviceUtils.isDesktopScreen(context)
            ? IconButton(onPressed: () => scaffoldKey?.currentState?.openDrawer(), icon: const Icon(Iconsax.menu))
            : null,

        /// Search Field
        // title: PDeviceUtils.isDesktopScreen(context)
        //     ? SizedBox(
        //       width: 400,
        //       child: TextFormField(
        //         decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal), hintText: 'Search anything...'),
        //       ),
        //     ) : null,

        /// Actions
         actions: [
        //   if (!PDeviceUtils.isDesktopScreen(context)) IconButton(onPressed: () {}, icon: const Icon(Iconsax.search_normal)),
          
          // Notification Icon
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.notification)),
          const SizedBox(width: PSizes.spaceBtwItems /2),
          
          // User Data
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image
              Obx(
                () => PRoundedImage(
                  width: 40,
                  padding: 2,
                  height: 40,
                  imageType: controller.user.value.profilePicture.isNotEmpty ? ImageType.network : ImageType.asset,
                 // image: controller.user.value.profilePicture.isNotEmpty ? controller.user.value.profilePicture : PImages.user,
                  image: PImages.user,
                ),
              ),
              const SizedBox(width: PSizes.sm),

              // Name and Email
              if (!PDeviceUtils.isMobileScreen(context))
                Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.loading.value
                        ? const PShimmerEffect(width: 50, height: 13)
                        : Text(controller.user.value.fullName, style: Theme.of(context).textTheme.titleLarge),
                      controller.loading.value
                          ? const PShimmerEffect(width: 50, height: 13)
                          : Text(controller.user.value.email, style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(PDeviceUtils.getAppBarHeight() + 15);
}

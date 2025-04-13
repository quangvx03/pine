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

import '../../../../features/shop/controllers/dashboard/notification_controller.dart';
import '../../../../utils/constants/colors.dart';

class PHeader extends StatelessWidget implements PreferredSizeWidget {
  const PHeader({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final notificationController = Get.put(NotificationController());

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

        /// Actions
        actions: [
      PopupMenuButton<int>(
      icon: Stack(
        clipBehavior: Clip.none, // Allow badge to overlap icon
        children: [
          const Icon(Icons.notifications),
          Obx(() {
            return notificationController.unreadCount.value > 0
                ? Positioned(
              right: 0,
              top: 0,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: Text(
                  notificationController.unreadCount.value.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            )
                : const SizedBox(); // If no unread notifications, don't show badge
          }),
        ],
      ),
      onSelected: (value) {
        if (value == 1) {
          // Mark all notifications as read
          notificationController.markAllAsRead();
        }
      },
      itemBuilder: (context) {
        return [
          // Header - Title of Popup
          PopupMenuItem<int>(
            enabled: false,
            child: Text(
              'Thông Báo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const PopupMenuDivider(),

          // List of Notifications
          ...List.generate(
            notificationController.notifications.length,
                (index) {
              final notification = notificationController.notifications[index];
              return PopupMenuItem<int>(
                value: index,
                onTap: () {
                  // Mark this notification as read when tapped
                  notificationController.notifications[index].isRead = true;
                  notificationController.updateUnreadCount();
                },
                child: ListTile(
                  title: Text(notification.title),
                  subtitle: Text(notification.message),
                  trailing: notification.isRead
                      ? Icon(Icons.check, color: Colors.green)
                      : Icon(Icons.new_releases, color: Colors.red),
                ),
              );
            },
          ),

          // Footer - Mark All as Read
          PopupMenuItem<int>(
            value: 1,
            child: const Text('Đánh dấu tất cả là đã đọc'),
          ),
        ];
      },
    ),
          const SizedBox(width: PSizes.spaceBtwItems / 2),

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
                  image: controller.user.value.profilePicture.isNotEmpty ? controller.user.value.profilePicture : PImages.user,
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
  Size get preferredSize => Size.fromHeight(PDeviceUtils.getAppBarHeight() + 15);
}

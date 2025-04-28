import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/common/widgets/layouts/sidebars/sidebar_controller.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';

import '../../../../routes/routes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'menu/menu_item.dart';

class PSidebar extends StatelessWidget {
  const PSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.put(SidebarController());
    return Obx(() {
      final userRole = sidebarController.userRole.value;

      return Drawer(
        shape: const BeveledRectangleBorder(),
        child: Container(
          decoration: const BoxDecoration(
            color: PColors.white,
            border: Border(right: BorderSide(color: PColors.grey, width: 1)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const PRoundedImage(
                  width: 100,
                  height: 100,
                  image: PImages.lightAppLogo,
                  backgroundColor: Colors.transparent,
                  imageType: ImageType.asset,
                ),
                const SizedBox(height: PSizes.spaceBtwSections),
                Padding(
                  padding: const EdgeInsets.all(PSizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Menu', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),

                      PMenuItem(
                        route: userRole == 'staff' ? PRoutes.staffDashboard : PRoutes.dashboard,
                        icon: Iconsax.status,
                        itemName: 'Bảng điều khiển',
                      ),
                      const PMenuItem(route: PRoutes.media, icon: Iconsax.image, itemName: 'Hình ảnh'),
                      const PMenuItem(route: PRoutes.categories, icon: Iconsax.category_2, itemName: 'Danh mục'),
                      const PMenuItem(route: PRoutes.brands, icon: Iconsax.dcube, itemName: 'Thương hiệu'),
                      const PMenuItem(route: PRoutes.products, icon: Iconsax.shopping_bag, itemName: 'Sản phẩm'),

                      if (userRole == 'admin') ...[
                        const PMenuItem(route: PRoutes.banners, icon: Iconsax.picture_frame, itemName: 'Banner'),
                        const PMenuItem(route: PRoutes.coupons, icon: Iconsax.ticket_discount, itemName: 'Mã giảm giá'),
                        const PMenuItem(route: PRoutes.customers, icon: Iconsax.profile_2user, itemName: 'Người dùng'),
                        const PMenuItem(route: PRoutes.reviews, icon: Iconsax.message, itemName: 'Đánh giá'),
                      ],

                      const PMenuItem(route: PRoutes.orders, icon: Iconsax.box, itemName: 'Đơn hàng'),
                      const PMenuItem(route: PRoutes.suppliers, icon: Iconsax.truck, itemName: 'Nhập hàng'),

                      Text('Khác', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                      const PMenuItem(route: PRoutes.profile, icon: Iconsax.user, itemName: 'Tài khoản'),
                      const PMenuItem(route: PRoutes.login, icon: Iconsax.logout, itemName: 'Đăng xuất'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

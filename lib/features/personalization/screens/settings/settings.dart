import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:pine/common/widgets/images/circular_image.dart';
import 'package:pine/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/data/repositories/authentication/authentication_repository.dart';
import 'package:pine/features/personalization/screens/address/address.dart';
import 'package:pine/features/shop/screens/cart/cart.dart';
import 'package:pine/features/shop/screens/order/order.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';

import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../profile/profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            PPrimaryHeaderContainer(
                child: Column(
              children: [
                /// AppBar
                PAppBar(
                    title: Text(
                  'Tài khoản',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .apply(color: PColors.white),
                )),

                /// User Profile Card
                PUserProfileTile(
                    onPressed: () => Get.to(() => const ProfileScreen())),
                const SizedBox(
                  height: PSizes.spaceBtwSections,
                ),
              ],
            )),

            /// Body
            Padding(
              padding: const EdgeInsets.all(PSizes.defaultSpace),
              child: Column(
                children: [
                  ///
                  PSectionHeading(
                    title: 'Cài đặt tài khoản',
                    showActionButton: false,
                  ),
                  SizedBox(
                    height: PSizes.spaceBtwItems,
                  ),

                  PSettingMenuTile(
                    icon: Iconsax.safe_home,
                    title: 'Địa chỉ',
                    subTitle: 'Cài đặt địa chỉ giao hàng',
                    onTap: () => Get.to(() => const UserAddressScreen()),
                  ),
                  PSettingMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: 'Giỏ hàng',
                    subTitle: 'Thêm, xóa sản phẩm và tiến hành thanh toán',
                    onTap: () => Get.to(() => const CartScreen()),
                  ),
                  PSettingMenuTile(
                    icon: Iconsax.bag_tick,
                    title: 'Đơn hàng',
                    subTitle: 'Đơn hàng đang xử lý và đã hoàn thành',
                    onTap: () => Get.to(() => const OrderScreen()),
                  ),
                  PSettingMenuTile(
                    icon: Iconsax.bank,
                    title: 'Tài khoản ngân hàng',
                    subTitle: 'Rút tiền vào tài khoản ngân hàng đã đăng ký',
                    onTap: () {},
                  ),
                  PSettingMenuTile(
                    icon: Iconsax.discount_shape,
                    title: 'Mã giảm giá',
                    subTitle: 'Danh sách tất cả mã giảm giá',
                    onTap: () {},
                  ),
                  PSettingMenuTile(
                    icon: Iconsax.notification,
                    title: 'Thông báo',
                    subTitle: 'Cài đặt các loại thông báo',
                    onTap: () {},
                  ),
                  PSettingMenuTile(
                    icon: Iconsax.security_card,
                    title: 'Quyền riêng tư',
                    subTitle: 'Quản lý dữ liệu và tài khoản đã liên kết',
                    onTap: () {},
                  ),

                  // /// App Settings
                  // SizedBox(height: PSizes.spaceBtwSections),
                  // PSectionHeading(
                  //     title: 'Cài đặt ứng dụng', showActionButton: false),
                  // SizedBox(height: PSizes.spaceBtwItems),
                  // PSettingMenuTile(
                  //   icon: Iconsax.document_upload,
                  //   title: 'Tải dữ liệu',
                  //   subTitle: 'Tải dữ liệu của bạn lên Cloud Firebase',
                  //   onTap: () {},
                  // ),
                  // PSettingMenuTile(
                  //   icon: Iconsax.location,
                  //   title: 'Định vị địa lý',
                  //   subTitle: 'Cài đặt gợi ý dựa trên vị trí',
                  //   trailing: Switch(value: true, onChanged: (value) {}),
                  // ),
                  // PSettingMenuTile(
                  //   icon: Iconsax.security_user,
                  //   title: 'Chế độ an toàn',
                  //   subTitle: 'Kết quả tìm kiếm an toàn cho mọi lứa tuổi',
                  //   trailing: Switch(value: false, onChanged: (value) {}),
                  // ),
                  // PSettingMenuTile(
                  //   icon: Iconsax.image,
                  //   title: 'Chất lượng hình ảnh HD',
                  //   subTitle: 'Cài đặt chất lượng hình ảnh hiển thị',
                  //   trailing: Switch(value: false, onChanged: (value) {}),
                  // ),

                  /// Logout Button
                  const SizedBox(height: PSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () async {
                          await AuthenticationRepository.instance.logout();
                        },
                        child: const Text('Đăng xuất')),
                  ),
                  const SizedBox(
                    height: PSizes.spaceBtwSections,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/features/personalization/controllers/user_controller.dart';
import 'package:pine/features/personalization/screens/address/address.dart';
import 'package:pine/features/shop/screens/cart/cart.dart';
import 'package:pine/features/shop/screens/order/order.dart';
import 'package:pine/features/shop/screens/wishlist/wishlist.dart';
import 'package:pine/routes/routes.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import '../profile/profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main content
            Column(
              children: [
                _buildHeaderWithQuickAccess(context, userController, isDark),

                SizedBox(height: PHelperFunctions.screenHeight() * 0.065),

                // Phần menu với các mục cài đặt
                Padding(
                  padding: const EdgeInsets.all(PSizes.defaultSpace),
                  child: Column(
                    children: [
                      // Phần tài khoản
                      _buildSettingsGroup(context, "Tài khoản", [
                        _buildSettingItem(
                          context,
                          icon: Iconsax.user_edit,
                          iconColor: PColors.primary,
                          title: "Thông tin cá nhân",
                          onTap: () => Get.toNamed(PRoutes.userProfile),
                        ),
                        _buildSettingItem(
                          context,
                          icon: Iconsax.safe_home,
                          iconColor: Colors.blue,
                          title: "Địa chỉ giao hàng",
                          onTap: () => Get.toNamed(PRoutes.userAddress),
                        ),
                        _buildSettingItem(
                          context,
                          icon: Iconsax.heart,
                          iconColor: Colors.red,
                          title: "Sản phẩm yêu thích",
                          onTap: () => Get.toNamed(PRoutes.favorites),
                        ),
                        _buildSettingItem(
                          context,
                          icon: Iconsax.bank,
                          iconColor: Colors.purple,
                          title: "Tài khoản ngân hàng",
                          onTap: () {},
                        ),
                      ]),

                      const SizedBox(height: PSizes.spaceBtwSections),

                      // Phần mua sắm
                      _buildSettingsGroup(context, "Mua sắm", [
                        _buildSettingItem(
                          context,
                          icon: Iconsax.bag_2,
                          iconColor: Colors.blue,
                          title: "Giỏ hàng",
                          subtitle: "Xem và chỉnh sửa giỏ hàng của bạn",
                          onTap: () => Get.toNamed(PRoutes.cart),
                        ),
                        _buildSettingItem(
                          context,
                          icon: Iconsax.receipt_item,
                          iconColor: Colors.purple,
                          title: "Đơn hàng",
                          subtitle: "Xem và theo dõi đơn hàng của bạn",
                          onTap: () => Get.toNamed(PRoutes.order),
                        ),
                        _buildSettingItem(
                          context,
                          icon: Iconsax.discount_shape,
                          iconColor: Colors.pinkAccent,
                          title: "Mã giảm giá",
                          subtitle: "Danh sách mã giảm giá hiện có",
                          onTap: () {},
                        ),
                      ]),

                      const SizedBox(height: PSizes.spaceBtwSections),

                      // Phần cài đặt ứng dụng
                      _buildSettingsGroup(context, "Cài đặt ứng dụng", [
                        _buildSettingItem(
                          context,
                          icon: Iconsax.notification,
                          iconColor: Colors.red,
                          title: "Thông báo",
                          hasSwitch: true,
                          onToggle: (value) {},
                        ),
                        _buildSettingItem(
                          context,
                          icon: Iconsax.security_safe,
                          iconColor: Colors.teal,
                          title: "Quyền riêng tư",
                          subtitle:
                              "Quản lý dữ liệu tài khoản và quyền riêng tư",
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          context,
                          icon: isDark ? Iconsax.sun_1 : Iconsax.moon,
                          iconColor: isDark ? Colors.amber : Colors.blueGrey,
                          title: "Chế độ tối",
                          hasSwitch: true,
                          switchValue: isDark,
                          onToggle: (value) {
                            Get.changeThemeMode(
                                value ? ThemeMode.dark : ThemeMode.light);
                          },
                        ),
                      ]),

                      const SizedBox(height: PSizes.spaceBtwSections),

                      // Nút đăng xuất
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Colors.red.withValues(alpha: 0.3)),
                            padding:
                                const EdgeInsets.symmetric(vertical: PSizes.md),
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            await AuthenticationRepository.instance.logout();
                          },
                          icon: const Icon(Iconsax.logout, color: Colors.red),
                          label: const Text('Đăng xuất'),
                        ),
                      ),

                      const SizedBox(height: PSizes.defaultSpace),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWithQuickAccess(
      BuildContext context, UserController userController, bool isDark) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Header
        Column(
          children: [
            AppBar(
              titleSpacing: 8,
              title: Padding(
                padding: const EdgeInsets.only(left: PSizes.defaultSpace),
                child: Text(
                  'Tài khoản',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              backgroundColor: PColors.primary,
            ),
            _buildProfileHeader(context, userController, isDark),
          ],
        ),

        // Quick Access Menu - positioned relative to header
        Positioned(
          bottom: -45,
          left: PSizes.defaultSpace,
          right: PSizes.defaultSpace,
          child: _buildQuickAccessMenu(context),
        ),

        // Spacer to push content below the quick access menu
        SizedBox(height: 60), // Điều chỉnh chiều cao phù hợp với menu
      ],
    );
  }

  // Header với avatar và thông tin người dùng
  Widget _buildProfileHeader(
      BuildContext context, UserController userController, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 45), // Tăng padding bottom
      decoration: const BoxDecoration(
        color: PColors.primary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: PSizes.spaceBtwItems / 2),

          // Avatar
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Obx(() => CircleAvatar(
                  radius: 30,
                  backgroundColor: PColors.white,
                  backgroundImage: NetworkImage(userController
                          .user.value.profilePicture.isNotEmpty
                      ? userController.user.value.profilePicture
                      : 'https://firebasestorage.googleapis.com/v0/b/pine-cadf8.firebasestorage.app/o/Users%2FImages%2FProfile%2Fuser.png?alt=media&token=2bbb5438-40ee-4b57-9848-cd7b9adea31f'),
                )),
          ),
          const SizedBox(height: PSizes.spaceBtwItems / 2),

          // Tên người dùng
          Obx(() => Text(
                userController.user.value.fullName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              )),

          // Email
          Obx(() => Text(
                userController.user.value.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
              )),

          // Khoảng cách để menu quick access
          const SizedBox(height: PSizes.defaultSpace),
        ],
      ),
    );
  }

  // Menu truy cập nhanh với các icon
  Widget _buildQuickAccessMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(PSizes.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickAccessItem(
              context,
              icon: Iconsax.bag_2,
              label: "Giỏ hàng",
              color: Colors.blue,
              onTap: () => Get.toNamed(PRoutes.cart),
            ),
            _buildQuickAccessItem(
              context,
              icon: Iconsax.heart,
              label: "Yêu thích",
              color: Colors.red,
              onTap: () => Get.toNamed(PRoutes.favorites),
            ),
            _buildQuickAccessItem(
              context,
              icon: Iconsax.receipt_item,
              label: "Đơn hàng",
              color: Colors.purple,
              onTap: () => Get.toNamed(PRoutes.order),
            ),
            _buildQuickAccessItem(
              context,
              icon: Iconsax.user_edit,
              label: "Cá nhân",
              color: Colors.green,
              onTap: () => Get.toNamed(PRoutes.userProfile),
            ),
          ],
        ),
      ),
    );
  }

  // Item trong menu truy cập nhanh (thu nhỏ lại)
  Widget _buildQuickAccessItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.all(PSizes.sm), // Giảm padding từ md xuống sm
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22), // Giảm kích thước icon
          ),
          const SizedBox(height: PSizes.spaceBtwItems / 2),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall, // Giảm cỡ chữ từ medium xuống small
          ),
        ],
      ),
    );
  }

  // Nhóm cài đặt - giữ nguyên code
  Widget _buildSettingsGroup(
      BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: PSizes.spaceBtwItems),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(PSizes.cardRadiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  // Item cài đặt - giữ nguyên code
  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool hasSwitch = false,
    bool switchValue = false,
    Function(bool)? onToggle,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(PSizes.md),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          subtitle: subtitle != null
              ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall)
              : null,
          trailing: hasSwitch
              ? Switch(
                  value: switchValue,
                  activeColor: PColors.primary,
                  onChanged: onToggle,
                )
              : trailing ??
                  (onTap != null
                      ? Icon(
                          Iconsax.arrow_right_3,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha: 0.5),
                        )
                      : null),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: PSizes.md, vertical: 4),
          onTap: hasSwitch ? null : onTap,
        ),
        Divider(
          height: 1,
          indent: 70,
          endIndent: 16,
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}

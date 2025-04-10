import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/shimmers/shimmer.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/personalization/controllers/user_controller.dart';
import 'package:pine/features/personalization/screens/profile/widgets/edit_profile.dart';
import 'package:pine/features/personalization/screens/profile/widgets/change_password.dart';
import 'package:pine/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  final UserController controller = UserController.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Tải dữ liệu khi màn hình được tạo
    _refreshUserData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Tải lại dữ liệu khi màn hình được focus lại
    _refreshUserData();
  }

  // Phương thức để tải lại dữ liệu người dùng từ Firebase
  Future<void> _refreshUserData() async {
    setState(() => _isLoading = true);
    try {
      // Tải dữ liệu mới từ Firestore
      await controller.fetchUserRecord();
    } catch (e) {
      print('Lỗi khi tải dữ liệu người dùng: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        title: const Text('Hồ sơ'),
      ),

      /// Body
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(PSizes.defaultSpace),
                  child: Column(
                    children: [
                      /// Profile Picture
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Obx(() {
                              final networkImage =
                                  controller.user.value.profilePicture;
                              return controller.imageUploading.value
                                  ? const PShimmerEffect(
                                      width: 100,
                                      height: 100,
                                      radius: 100,
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: PColors.primary, width: 2),
                                      ),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: PColors.primary,
                                        backgroundImage: NetworkImage(networkImage
                                                .isNotEmpty
                                            ? networkImage
                                            : 'https://firebasestorage.googleapis.com/v0/b/pine-cadf8.firebasestorage.app/o/Users%2FImages%2FProfile%2Fuser.png?alt=media&token=2bbb5438-40ee-4b57-9848-cd7b9adea31f'),
                                      ),
                                    );
                            }),
                            TextButton(
                                onPressed: () =>
                                    controller.uploadUserProfilePicture(),
                                child: const Text('Thay đổi ảnh đại diện'))
                          ],
                        ),
                      ),

                      /// Details
                      const SizedBox(height: PSizes.spaceBtwItems / 2),
                      const Divider(),
                      const SizedBox(height: PSizes.spaceBtwItems),

                      /// Thông tin không thể thay đổi
                      const PSectionHeading(
                          title: 'Thông tin tài khoản',
                          showActionButton: false),
                      const SizedBox(height: PSizes.spaceBtwItems),

                      PProfileMenu(
                        title: 'ID người dùng',
                        value: controller.user.value.id,
                      ),
                      PProfileMenu(
                        title: 'Tên tài khoản',
                        value: controller.user.value.username,
                      ),

                      const SizedBox(height: PSizes.spaceBtwItems),
                      const Divider(),
                      const SizedBox(height: PSizes.spaceBtwItems),

                      /// Thông tin cá nhân - có thể chỉnh sửa
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const PSectionHeading(
                              title: 'Thông tin cá nhân',
                              showActionButton: false),
                          TextButton(
                            onPressed: () async {
                              await Get.to(() => const EditProfileScreen());
                              // Làm mới dữ liệu khi quay lại từ màn hình chỉnh sửa
                              _refreshUserData();
                            },
                            child: const Text('Chỉnh sửa'),
                          ),
                        ],
                      ),

                      const SizedBox(height: PSizes.spaceBtwItems),

                      // Hiển thị thông tin cá nhân
                      PProfileMenu(
                        title: 'Họ và tên',
                        value: controller.user.value.fullName,
                      ),
                      PProfileMenu(
                        title: 'E-mail',
                        value: controller.user.value.email,
                      ),
                      PProfileMenu(
                        title: 'Số điện thoại',
                        value: controller.user.value.phoneNumber,
                      ),
                      PProfileMenu(
                        title: 'Giới tính',
                        value: controller.user.value.gender.isNotEmpty
                            ? controller.user.value.gender
                            : 'Chưa cập nhật',
                      ),
                      PProfileMenu(
                        title: 'Ngày sinh',
                        value: controller.user.value.dateOfBirth.isNotEmpty
                            ? controller.user.value.dateOfBirth
                            : 'Chưa cập nhật',
                      ),

                      const SizedBox(height: PSizes.spaceBtwItems),
                      const Divider(),
                      const SizedBox(height: PSizes.spaceBtwItems),

                      /// Bảo mật
                      const PSectionHeading(
                          title: 'Bảo mật', showActionButton: false),
                      const SizedBox(height: PSizes.spaceBtwItems),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: PColors.primary.withValues(alpha: 0.3)),
                            padding:
                                const EdgeInsets.symmetric(vertical: PSizes.md),
                            foregroundColor: PColors.primary,
                          ),
                          onPressed: () =>
                              Get.to(() => const ChangePasswordScreen()),
                          icon: const Icon(Iconsax.password_check),
                          label: Text('Thay đổi mật khẩu',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: PColors.primary)),
                        ),
                      ),

                      const SizedBox(height: PSizes.spaceBtwSections),
                      const Divider(),
                      const SizedBox(height: PSizes.spaceBtwItems),

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
                          onPressed: () =>
                              controller.deleteAccountWarningPopup(),
                          icon: const Icon(
                            Iconsax.close_circle,
                            color: Colors.red,
                          ),
                          label: Text('Xoá tài khoản',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(height: PSizes.defaultSpace)
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

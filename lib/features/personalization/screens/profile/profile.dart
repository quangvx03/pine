import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/images/circular_image.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/personalization/controllers/user_controller.dart';
import 'package:pine/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:pine/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        title: Text('Hồ sơ'),
      ),

      /// Body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            children: [
              /// Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    PCircularImage(image: PImages.user, width: 80, height: 80),
                    TextButton(
                        onPressed: () {},
                        child: const Text('Thay đổi ảnh đại diện'))
                  ],
                ),
              ),

              /// Details
              const SizedBox(height: PSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: PSizes.spaceBtwItems),

              /// Heading Profile Info
              const PSectionHeading(
                  title: 'Thông tin hồ sơ', showActionButton: false),
              const SizedBox(
                height: PSizes.spaceBtwItems,
              ),

              PProfileMenu(
                title: 'Tên',
                value: controller.user.value.fullName,
                onPressed: () => Get.to(() => const ChangeNameScreen()),
              ),
              PProfileMenu(
                title: 'Tài khoản',
                value: controller.user.value.username,
                onPressed: () {},
              ),

              const SizedBox(height: PSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: PSizes.spaceBtwItems),

              /// Heading Personal Info
              const PSectionHeading(
                  title: 'Thông tin cá nhân', showActionButton: false),
              const SizedBox(height: PSizes.spaceBtwItems),

              PProfileMenu(
                title: 'ID người dùng',
                value: controller.user.value.id,
                icon: Iconsax.copy,
                onPressed: () {},
              ),
              PProfileMenu(
                title: 'E-mail',
                value: controller.user.value.email,
                onPressed: () {},
              ),
              PProfileMenu(
                title: 'Số điện thoại',
                value: controller.user.value.phoneNumber,
                onPressed: () {},
              ),
              PProfileMenu(
                title: 'Giới tính',
                value: 'Nam',
                onPressed: () {},
              ),
              PProfileMenu(
                title: 'Ngày sinh',
                value: '1/1/2003',
                onPressed: () {},
              ),

              const Divider(),
              const SizedBox(height: PSizes.spaceBtwItems),

              Center(
                child: TextButton(
                    onPressed: () => controller.deleteAccountWarningPopup(),
                    child: Text(
                      'Xoá tài khoản',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: PColors.favorite),
                    )),
              ),
              const SizedBox(height: PSizes.spaceBtwItems)
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/validators/validation.dart';
import 'package:pine/utils/popups/full_screen_loader.dart';
import 'package:pine/utils/popups/loaders.dart';
import 'package:pine/utils/constants/image_strings.dart';

import '../../../controllers/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        title: const Text('Thay đổi mật khẩu'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Form(
            key: controller.changePasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mật khẩu hiện tại
                Obx(
                  () => TextFormField(
                    controller: controller.currentPassword,
                    validator: (value) => PValidator.validatePassword(value),
                    obscureText: controller.hideCurrentPassword.value,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu hiện tại',
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hideCurrentPassword.value =
                            !controller.hideCurrentPassword.value,
                        icon: Icon(controller.hideCurrentPassword.value
                            ? Iconsax.eye_slash
                            : Iconsax.eye),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: PSizes.spaceBtwItems),

                // Mật khẩu mới
                Obx(
                  () => TextFormField(
                    controller: controller.newPassword,
                    validator: (value) => PValidator.validatePassword(value),
                    obscureText: controller.hideNewPassword.value,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu mới',
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hideNewPassword.value =
                            !controller.hideNewPassword.value,
                        icon: Icon(controller.hideNewPassword.value
                            ? Iconsax.eye_slash
                            : Iconsax.eye),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: PSizes.spaceBtwItems),

                // Nhập lại mật khẩu mới
                Obx(
                  () => TextFormField(
                    controller: controller.confirmPassword,
                    validator: (value) {
                      if (value != controller.newPassword.text) {
                        return 'Mật khẩu xác nhận không khớp';
                      }
                      return null;
                    },
                    obscureText: controller.hideConfirmPassword.value,
                    decoration: InputDecoration(
                      labelText: 'Xác nhận mật khẩu mới',
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hideConfirmPassword.value =
                            !controller.hideConfirmPassword.value,
                        icon: Icon(controller.hideConfirmPassword.value
                            ? Iconsax.eye_slash
                            : Iconsax.eye),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: PSizes.spaceBtwSections),

                // Nút cập nhật
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.changePassword(),
                    child: const Text('Cập nhật mật khẩu'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


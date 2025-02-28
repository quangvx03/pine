import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/authentication/controllers/login/login_controller.dart';
import 'package:pine/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:pine/features/authentication/screens/signup/signup.dart';
import 'package:pine/navigation_menu.dart';
import 'package:pine/utils/validators/validation.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class PLoginForm extends StatelessWidget {
  const PLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
        key: controller.loginFormKey,
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: PSizes.spaceBtwSections),
            child: Column(
              children: [
                /// Email
                TextFormField(
                  controller: controller.email,
                  validator: (value) => PValidator.validateEmail(value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: PTexts.email,
                  ),
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields),

                // Password
                Obx(
                  () => TextFormField(
                      validator: (value) => PValidator.validatePassword(value),
                      controller: controller.password,
                      obscureText: controller.hidePassword.value,
                      decoration: InputDecoration(
                          labelText: PTexts.password,
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            onPressed: () => controller.hidePassword.value =
                                !controller.hidePassword.value,
                            icon: Icon(controller.hidePassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye),
                          ))),
                ),
                const SizedBox(height: PSizes.spaceBtwInputFields / 2),

                /// Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Remember Me
                    Row(
                      children: [
                        Obx(() => Checkbox(
                            value: controller.rememberMe.value,
                            onChanged: (value) => controller.rememberMe.value =
                                !controller.rememberMe.value)),
                        const Text(PTexts.rememberMe),
                      ],
                    ),

                    /// Forgot Password
                    TextButton(
                        onPressed: () => Get.to(() => const ForgotPassword()),
                        child: const Text(PTexts.forgotPassword)),
                  ],
                ),
                const SizedBox(height: PSizes.spaceBtwSections),

                /// Sign In Button
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () => controller.emailAndPasswordSignIn(),
                        child: const Text(PTexts.signIn))),
                const SizedBox(height: PSizes.spaceBtwItems),

                /// Create Account Button
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () => Get.to(() => const SignupScreen()),
                        child: const Text(PTexts.createAccount))),
              ],
            )));
  }
}

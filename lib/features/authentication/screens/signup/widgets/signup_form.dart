import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/authentication/controllers/signup/signup_controller.dart';
import 'package:pine/features/authentication/screens/signup/widgets/terms_condition_checkbox.dart';
import 'package:pine/utils/validators/validation.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class PSignupForm extends StatelessWidget {
  const PSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: controller.firstName,
                validator: (value) =>
                    PValidator.validateEmptyText('Tên', value),
                expands: false,
                decoration: const InputDecoration(
                    labelText: PTexts.firstName,
                    prefixIcon: Icon(Iconsax.user)),
              )),
              const SizedBox(width: PSizes.spaceBtwInputFields),
              Expanded(
                  child: TextFormField(
                controller: controller.lastName,
                validator: (value) => PValidator.validateEmptyText('Họ', value),
                expands: false,
                decoration: const InputDecoration(
                    labelText: PTexts.lastName, prefixIcon: Icon(Iconsax.user)),
              ))
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwInputFields),

          /// Username
          TextFormField(
            validator: (value) =>
                PValidator.validateEmptyText('Tên người dùng', value),
            controller: controller.username,
            expands: false,
            decoration: const InputDecoration(
                labelText: PTexts.username,
                prefixIcon: Icon(Iconsax.user_edit)),
          ),
          const SizedBox(height: PSizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            validator: (value) => PValidator.validateEmail(value),
            controller: controller.email,
            expands: false,
            decoration: const InputDecoration(
                labelText: PTexts.email, prefixIcon: Icon(Iconsax.direct)),
          ),
          const SizedBox(height: PSizes.spaceBtwInputFields),

          /// Phone Number
          TextFormField(
            validator: (value) => PValidator.validatePhoneNumber(value),
            controller: controller.phoneNumber,
            expands: false,
            decoration: const InputDecoration(
                labelText: PTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
          ),
          const SizedBox(height: PSizes.spaceBtwInputFields),

          /// Password
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
          const SizedBox(height: PSizes.spaceBtwSections),

          /// Terms & Conditions Checkbox
          const PTermsAndConditionCheckbox(),
          const SizedBox(height: PSizes.spaceBtwSections),

          /// Signup Button
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.signup(),
                  child: const Text(PTexts.createAccount))),
        ],
      ),
    );
  }
}

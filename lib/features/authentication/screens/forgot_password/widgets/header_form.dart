import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class HeaderAndForm extends StatelessWidget {
  const HeaderAndForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left)),
        const SizedBox(height: PSizes.spaceBtwItems),
        Text(PTexts.forgotPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: PSizes.spaceBtwItems),
        Text(PTexts.forgotPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: PSizes.spaceBtwSections * 2),

        /// Form
        Form(
          child: TextFormField(
            decoration: const InputDecoration(labelText: PTexts.email, prefixIcon: Icon(Iconsax.direct_right)),
          ),
        ),
        const SizedBox(height: PSizes.spaceBtwSections),

        /// Submit Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () => Get.toNamed(PRoutes.resetPassword, parameters: {'email' : 'test@gmail.com'}), child: const Text(PTexts.submit)),
        ),
        const SizedBox(height: PSizes.spaceBtwSections * 2),
      ],
    );
  }
}
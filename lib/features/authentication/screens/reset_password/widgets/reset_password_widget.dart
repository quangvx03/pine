import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final email = Get.parameters['email'] ?? '';

    return Column(
      children: [
        /// Header
        Row(
          children: [
            IconButton(onPressed: () => Get.offAllNamed(PRoutes.login), icon: const Icon(CupertinoIcons.clear)),
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems),

        /// Image
        const Image(image: AssetImage(PImages.deliveredEmailIllustration), width: 300, height: 300),
        const SizedBox(height: PSizes.spaceBtwItems),

        /// Title & SubTitle
        Text(PTexts.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: PSizes.spaceBtwItems),
        Text(email, style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
        const SizedBox(height: PSizes.spaceBtwItems),
        Text(PTexts.changeYourPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
        const SizedBox(height: PSizes.spaceBtwSections),

        /// Buttons
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () => Get.offAllNamed(PRoutes.login), child: const Text(PTexts.done)),
        ),
        const SizedBox(height: PSizes.spaceBtwItems),
        SizedBox(
          width: double.infinity,
          child: TextButton(onPressed: (){}, child: const Text(PTexts.resendEmail)),
        )
      ],
    );
  }
}
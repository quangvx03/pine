import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/signup/signup_controller.dart';

class PTermsAndConditionCheckbox extends StatelessWidget {
  const PTermsAndConditionCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = PHelperFunctions.isDarkMode(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 24,
            height: 24,
            child: Obx(() => Checkbox(
                value: controller.privacyPolicy.value,
                onChanged: (value) => controller.privacyPolicy.value =
                    !controller.privacyPolicy.value))),
        const SizedBox(width: PSizes.spaceBtwItems),
        Expanded(
            child: Text.rich(
          TextSpan(children: [
            TextSpan(
                text: '${PTexts.iAgreeTo} ',
                style: Theme.of(context).textTheme.bodySmall),
            TextSpan(
                text: '${PTexts.privacyPolicy} ',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? PColors.white : PColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: dark ? PColors.white : PColors.primary,
                    )),
            TextSpan(text: 'và ', style: Theme.of(context).textTheme.bodySmall),
            TextSpan(
                text: PTexts.termsOfUse,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? PColors.white : PColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: dark ? PColors.white : PColors.primary,
                    ))
          ]),
          softWrap: true,
        ))
      ],
    );
  }
}

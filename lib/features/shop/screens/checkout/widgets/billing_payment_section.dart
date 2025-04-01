import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../controllers/product/checkout_controller.dart';

class PBillingPaymentSection extends StatelessWidget {
  const PBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final dark = PHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        PSectionHeading(
            title: 'Phương thức thanh toán',
            buttonTitle: 'Thay đổi',
            onPressed: () => controller.selectPaymentMethod(context)),
        const SizedBox(height: PSizes.spaceBtwItems / 2),
        Obx(
          () => Row(
            children: [
              PRoundedContainer(
                width: 60,
                height: 35,
                backgroundColor: dark ? PColors.light : PColors.white,
                padding: const EdgeInsets.all(PSizes.xs),
                child:  Image(
                    image: AssetImage(controller.selectedPaymentMethod.value.image), fit: BoxFit.contain),
              ),
              const SizedBox(width: PSizes.spaceBtwItems / 2),
              Text(controller.selectedPaymentMethod.value.name,
                  style: Theme.of(context).textTheme.bodyLarge)
            ],
          ),
        )
      ],
    );
  }
}

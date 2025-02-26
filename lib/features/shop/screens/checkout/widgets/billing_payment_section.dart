import 'package:flutter/material.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PBillingPaymentSection extends StatelessWidget {
  const PBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark  = PHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        PSectionHeading(title: 'Phương thức thanh toán', buttonTitle: 'Thay đổi', onPressed: () {}),
        const SizedBox(height: PSizes.spaceBtwItems / 2),
        Row(
          children: [
            PRoundedContainer(
              width: 60,
              height: 35,
              backgroundColor: dark ? PColors.light : PColors.white,
              padding: const EdgeInsets.all(PSizes.sm),
              child: const Image(image: AssetImage(PImages.cod), fit: BoxFit.contain),
            ),
            const SizedBox(width: PSizes.spaceBtwItems / 2),
            Text('Thanh toán khi nhận hàng', style: Theme.of(context).textTheme.bodyLarge)
          ],
        )
      ],
    );
  }
}

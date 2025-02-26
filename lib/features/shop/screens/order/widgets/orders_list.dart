import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class POrderListItems extends StatelessWidget {
  const POrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: PSizes.spaceBtwItems),
      itemBuilder: (_, index) => PRoundedContainer(
        showBorder: true,
        padding: const EdgeInsets.all(PSizes.md),
        backgroundColor: dark ? PColors.dark : PColors.light,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                /// Icon
                const Icon(Icons.local_shipping_outlined),
                const SizedBox(width: PSizes.spaceBtwItems / 2),

                /// Status & Date
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đang vận chuyển',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: PColors.primary, fontWeightDelta: 1),
                      ),
                      Text('02/02/2025',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ),

                /// Icon
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Iconsax.arrow_right_34,
                        size: PSizes.iconSm)),
              ],
            ),
            const SizedBox(height: PSizes.spaceBtwItems),

            /// Row 2
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      /// Icon
                      const Icon(Iconsax.tag),
                      const SizedBox(width: PSizes.spaceBtwItems / 2),

                      /// Status & Date
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Đơn hàng',
                                style: Theme.of(context).textTheme.labelMedium),
                            Text('[#13225]',
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Row(
                          children: [
                            /// Icon
                            const Icon(Iconsax.calendar),
                            const SizedBox(width: PSizes.spaceBtwItems / 2),

                            /// Status & Date
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Ngày giao hàng',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium),
                                  Text('05/02/2025',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

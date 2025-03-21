import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';

class PRatingAndShare extends StatelessWidget {
  const PRatingAndShare({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Rating
        Row(
          children: [
            const Icon(Iconsax.star5, color: Colors.amber, size: 24),
            const SizedBox(width: PSizes.spaceBtwItems / 2),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: '4.7 ', style: Theme.of(context).textTheme.bodyLarge),
              const TextSpan(text: '(22)'),
            ]))
          ],
        ),

        /// Share Button
        // IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.share,
        //       size: PSizes.iconMd,
        //     ))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PSingleAddress extends StatelessWidget {
  const PSingleAddress({super.key, required this.selectedAddress});

  final bool selectedAddress;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return PRoundedContainer(
      width: double.infinity,
      showBorder: true,
      padding: const EdgeInsets.all(PSizes.md),
      backgroundColor: selectedAddress
          ? PColors.primary.withValues(alpha: 0.5)
          : Colors.transparent,
      borderColor: selectedAddress
          ? Colors.transparent
          : dark
              ? PColors.darkerGrey
              : PColors.grey,
      margin: const EdgeInsets.only(bottom: PSizes.spaceBtwItems),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            child: Icon(
              selectedAddress ? Iconsax.tick_circle5 : null,
              color: selectedAddress
                  ? dark
                      ? PColors.light
                      : PColors.dark
                  : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Người dùng Pine',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: PSizes.sm / 2),
              const Text('0987654321', maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: PSizes.sm / 2),
              const Text('1 Phù Đổng Thiên Vương, Phường 7, Đà Lạt, Lâm Đồng', softWrap: true)
            ],
          )
        ],
      ),
    );
  }
}

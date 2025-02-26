import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/authentication/controllers/onboarding/onboarding_controller.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final dark = PHelperFunctions.isDarkMode(context);

    return Positioned(
      right: PSizes.defaultSpace,
      bottom: PDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
          onPressed: () => OnBoardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(), backgroundColor: PColors.buttonPrimary, iconColor: PColors.white),
          // style: ElevatedButton.styleFrom(
          //     shape: const CircleBorder(), backgroundColor: dark ? PColors.primary : Colors.black),
          child: const Icon(Iconsax.arrow_right_3)),
    );
  }
}
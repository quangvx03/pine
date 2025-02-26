import 'package:flutter/material.dart';
import 'package:pine/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:pine/utils/constants/colors.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: PDeviceUtils.getAppBarHeight(),
        right: PSizes.defaultSpace,
        child: TextButton(
          onPressed: () => OnBoardingController.instance.skipPage(),
          child: const Text('Bỏ qua', style: TextStyle(color: PColors.primary, fontSize: 13, fontWeight: FontWeight.w500),),
        ));
  }
}

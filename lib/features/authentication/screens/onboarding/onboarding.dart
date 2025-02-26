import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:pine/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:pine/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:pine/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:pine/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/text_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
        body: Stack(
      children: [
        /// Horizontal Scrollable Pages
        PageView(
          controller: controller.pageController,
          onPageChanged: controller.updatePageIndicator,
          children: const [
            OnBoardingPage(
              image: PImages.onBoardingImage1,
              title: PTexts.onBoardingTitle1,
              subTitle: PTexts.onBoardingSubTitle1,
            ),
            OnBoardingPage(
              image: PImages.onBoardingImage2,
              title: PTexts.onBoardingTitle2,
              subTitle: PTexts.onBoardingSubTitle2,
            ),
            OnBoardingPage(
              image: PImages.onBoardingImage3,
              title: PTexts.onBoardingTitle3,
              subTitle: PTexts.onBoardingSubTitle3,
            )
          ],
        ),

        /// Skip Button
        const OnBoardingSkip(),

        /// Dot Navigation SmoothPageIndicator
        const OnBoardingDotNavigation(),

        /// Circular Button
        const OnBoardingNextButton()
      ],
    ));
  }
}



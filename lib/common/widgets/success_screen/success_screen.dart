import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pine/common/styles/spacing_styles.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.onPressed});

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: PSpacingStyle.paddingWithAppBarHeight * 2,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: PSizes.defaultSpace),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Image
                    Lottie.asset(image,
                        width: PHelperFunctions.screenWidth() * 0.8),
                    const SizedBox(height: PSizes.spaceBtwSections),

                    /// Title & SubTitle
                    Text(title,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: PSizes.defaultSpace),
                    Text(subTitle,
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: PSizes.spaceBtwSections * 2),

                    /// Buttons
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: onPressed,
                            child: const Text(PTexts.pContinue))),
                  ],
                ))),
      ),
    );
  }
}

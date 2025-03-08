import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/success_screen/success_screen.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/features/authentication/screens/login/login.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/constants/text_strings.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../controllers/signup/verify_email_controller.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => AuthenticationRepository.instance.logout(),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        // Padding to Give Default Equal Space on all sides in all screens
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            children: [
              /// Image
              Image(
                  image: AssetImage(PImages.deliveredEmailIllustration),
                  width: PHelperFunctions.screenWidth() * 0.6),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// Title & SubTitle
              Text(PTexts.confirmEmail,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: PSizes.spaceBtwItems),
              Text(email ?? '',
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: PSizes.spaceBtwItems),
              Text(PTexts.confirmEmailSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// Buttons
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => controller.checkEmailVerificationStatus(),
                      child: const Text(PTexts.pContinue))),
              const SizedBox(height: PSizes.spaceBtwItems),
              SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () => controller.sendEmailVerification(),
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          )),
                      child: const Text(PTexts.resendEmail))),
            ],
          ),
        ),
      ),
    );
  }
}

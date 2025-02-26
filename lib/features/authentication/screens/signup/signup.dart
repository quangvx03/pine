import 'package:flutter/material.dart';
import 'package:pine/common/widgets/login_signup/form_divider.dart';
import 'package:pine/common/widgets/login_signup/social_buttons.dart';
import 'package:pine/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/constants/text_strings.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                PTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// Form
              const PSignupForm(),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// Divider
              PFormDivider(dividerText: PTexts.orSignUpWith),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// Social Buttons
              const PSocialButtons(),
              const SizedBox(height: PSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}

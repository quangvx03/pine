import 'package:flutter/material.dart';
import 'package:pine/common/styles/spacing_styles.dart';
import 'package:pine/features/authentication/screens/login/widgets/login_form.dart';
import 'package:pine/features/authentication/screens/login/widgets/login_header.dart';
import 'package:pine/utils/constants/sizes.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: PSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title & Sub-Title
              const PLoginHeader(),

              /// Form
              const PLoginForm(),

              /// Divider
              PFormDivider(dividerText: PTexts.orSignInWith),
              const SizedBox(height: PSizes.defaultSpace),

              /// Footer
              const PSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
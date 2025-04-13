import 'package:flutter/material.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../widgets/signup_form.dart';
import '../widgets/signup_header.dart';

class SignupScreenMobile extends StatelessWidget {
  const SignupScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            children: [
              // Header
              PSignupHeader(),

              // Form
              PSignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}

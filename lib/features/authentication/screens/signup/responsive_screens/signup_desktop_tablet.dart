import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/login_signup_template.dart';
import 'package:pine_admin_panel/features/authentication/screens/login/widgets/login_form.dart';
import 'package:pine_admin_panel/features/authentication/screens/login/widgets/login_header.dart';

import '../widgets/signup_form.dart';
import '../widgets/signup_header.dart';

class SignupScreenDesktopTablet extends StatelessWidget {
  const SignupScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const PLoginSignupTemplate(
        child: Column(
        children: [
        // Header
        PSignupHeader(),

        // Form
        PSignupForm(),
        ],
      ),
    );
  }
}

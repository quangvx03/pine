import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/login_signup_template.dart';
import 'package:pine_admin_panel/features/authentication/screens/forgot_password/widgets/header_form.dart';

class ForgotPasswordScreenDesktopTablet extends StatelessWidget {
  const ForgotPasswordScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return PLoginSignupTemplate(
        child: HeaderAndForm(),
    );
  }
}

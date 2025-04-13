import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/login_signup_template.dart';
import 'package:pine_admin_panel/features/authentication/screens/login/widgets/login_form.dart';
import 'package:pine_admin_panel/features/authentication/screens/login/widgets/login_header.dart';

class LoginScreenDesktopTablet extends StatelessWidget {
  const LoginScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const PLoginSignupTemplate(
        child: Column(
        children: [
        // Header
        PLoginHeader(),

        // Form
        PLoginForm(),
        ],
      ),
    );
  }
}

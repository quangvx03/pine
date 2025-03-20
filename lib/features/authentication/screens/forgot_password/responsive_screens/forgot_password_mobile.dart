import 'package:flutter/material.dart';
import 'package:pine_admin_panel/features/authentication/screens/forgot_password/widgets/header_form.dart';

import '../../../../../utils/constants/sizes.dart';

class ForgotPasswordScreenMobile extends StatelessWidget {
  const ForgotPasswordScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(PSizes.defaultSpace),
          child: HeaderAndForm(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/authentication/screens/signup/responsive_screens/signup_desktop_tablet.dart';
import 'package:pine_admin_panel/features/authentication/screens/signup/responsive_screens/signup_mobile.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(useLayout: false, desktop: SignupScreenDesktopTablet(), mobile: SignupScreenMobile());
  }
}

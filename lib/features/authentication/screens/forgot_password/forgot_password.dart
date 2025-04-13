import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/authentication/screens/forgot_password/responsive_screens/forgot_password_desktop_tablet.dart';
import 'package:pine_admin_panel/features/authentication/screens/forgot_password/responsive_screens/forgot_password_mobile.dart';


class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(useLayout: false, desktop: ForgotPasswordScreenDesktopTablet(), mobile: ForgotPasswordScreenMobile());
  }
}

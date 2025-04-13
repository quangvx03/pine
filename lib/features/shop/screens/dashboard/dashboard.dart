import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/responsive_screens/dashboard_desktop.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(desktop: DashboardDesktopScreen());
  }
}

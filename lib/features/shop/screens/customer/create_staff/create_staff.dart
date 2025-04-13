import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/customer/create_staff/responsive_screens/create_staff_desktop.dart';
class CreateStaffScreen extends StatelessWidget {
  const CreateStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PSiteTemplate(desktop: CreateStaffDesktopScreen());
  }
}

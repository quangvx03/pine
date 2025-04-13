import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:pine_admin_panel/features/shop/screens/customer/edit_staff/responsive_screens/edit_staff_desktop.dart';

class EditStaffScreen extends StatelessWidget {
  const EditStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final staff = Get.arguments;
    return PSiteTemplate(desktop: EditStaffDesktopScreen(staff: staff));
  }
}

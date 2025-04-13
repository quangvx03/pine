import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

import '../../../../../../../routes/routes.dart';
import '../widgets/create_staff_form.dart';
import '../widgets/profile_picture.dart';

class CreateStaffDesktopScreen extends StatelessWidget {
  const CreateStaffDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              PBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Thêm nhân viên', breadcrumbItems: [{ 'label': 'Người dùng', 'path': PRoutes.customers }, 'Thêm nhân viên']),
              SizedBox(height: PSizes.spaceBtwSections),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: ProfilePicture()),
                  SizedBox(width: PSizes.spaceBtwSections),

                  // Form
                  Expanded(flex: 2, child: CreateStaffForm()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

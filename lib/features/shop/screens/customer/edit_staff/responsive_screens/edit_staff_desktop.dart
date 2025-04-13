import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';

import '../../../../../../../routes/routes.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../../personalization/models/user_model.dart';
import '../widgets/edit_profile_picture.dart';
import '../widgets/edit_staff_form.dart';

class EditStaffDesktopScreen extends StatelessWidget {
  const EditStaffDesktopScreen({super.key, required this.staff});

  final UserModel staff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumbs
              const PBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Cập nhật nhân viên', breadcrumbItems: [{ 'label': 'Người dùng', 'path': PRoutes.customers }, 'Cập nhật nhân viên']),
              const SizedBox(height: PSizes.spaceBtwSections),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: EditProfilePicture(staff: staff)),
                  SizedBox(width: PSizes.spaceBtwSections),

                  // Form
                  Expanded(flex: 2, child: EditStaffForm(staff: staff)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

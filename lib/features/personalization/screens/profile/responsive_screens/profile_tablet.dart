import 'package:flutter/material.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/profile_form.dart';
import '../widgets/profile_image_meta.dart';

class ProfileTabletScreen extends StatelessWidget {
  const ProfileTabletScreen({super.key});

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
              PBreadcrumbsWithHeading(heading: 'Tài khoản', breadcrumbItems: ['Tài khoản']),
              SizedBox(height: PSizes.spaceBtwSections),

              // Body
              Column(
                children: [
                  // Profile Pic and Meta
                  ImageAndMeta(),
                  SizedBox(height: PSizes.spaceBtwSections),

                  // Form
                  ProfileForm(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

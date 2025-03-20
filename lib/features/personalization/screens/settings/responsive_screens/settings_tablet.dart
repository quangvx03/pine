import 'package:flutter/material.dart';
import 'package:pine_admin_panel/features/personalization/screens/settings/widgets/settings_form.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/setting_image_meta.dart';

class SettingsTabletScreen extends StatelessWidget {
  const SettingsTabletScreen({super.key});

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
              PBreadcrumbsWithHeading(heading: 'Cài đặt', breadcrumbItems: ['Cài đặt']),
              SizedBox(height: PSizes.spaceBtwSections),

              // Body
              Column(
                children: [
                  // Profile Pic and Meta
                  ImageAndMeta(),
                  SizedBox(height: PSizes.spaceBtwSections),

                  // Form
                  SettingsForm(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

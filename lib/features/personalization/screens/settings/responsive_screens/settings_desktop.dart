import 'package:flutter/material.dart';
import 'package:pine_admin_panel/features/personalization/screens/settings/widgets/settings_form.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/setting_image_meta.dart';

class SettingsDesktopScreen extends StatelessWidget {
  const SettingsDesktopScreen({super.key});

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Pic and Meta
                  Expanded(child: ImageAndMeta()),
                  SizedBox(width: PSizes.spaceBtwSections),

                  // Form
                  Expanded(flex: 2, child: SettingsForm()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

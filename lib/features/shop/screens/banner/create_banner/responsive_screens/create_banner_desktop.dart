import 'package:flutter/material.dart';

import '../../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../widgets/create_banner_form.dart';

class CreateBannerDesktopScreen extends StatelessWidget {
  const CreateBannerDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Thêm banner', breadcrumbItems: [{ 'label': 'Banner', 'path': PRoutes.banners }, 'Thêm banner']),
              SizedBox(height: PSizes.spaceBtwSections),

              CreateBannerForm(),
            ],
          ),
        ),
      ),
    );
  }
}

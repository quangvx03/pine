import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/screens/banner/all_banners/table/banner_table.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';

class BannersMobileScreen extends StatelessWidget {
  const BannersMobileScreen({super.key});

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
              const PBreadcrumbsWithHeading(heading: 'Banner', breadcrumbItems: ['Banner']),
              const SizedBox(height: PSizes.spaceBtwSections),

              // Table Body
              // Show Loader
              PRoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    PTableHeader(buttonText: 'Thêm banner', onPressed: () => Get.toNamed(PRoutes.createBanner)),
                    const SizedBox(height: PSizes.spaceBtwItems),

                    // Table
                    const BannersTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
